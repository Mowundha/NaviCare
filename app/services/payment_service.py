"""
Payment intent creation (Razorpay order), escrow webhook handling, and the
automated caretaker payout engine — triggered by dispatch_service when a
booking reaches COMPLETED.
"""
import uuid
from datetime import datetime, timezone

from app.core.config import settings
from app.core.firestore_client import FirestoreRepository
from app.core.razorpay_client import create_order, initiate_payout, verify_webhook_signature
from app.models.caretaker import Caretaker
from app.models.enums import PaymentStatus, PayoutStatus
from app.models.payment import Payment, PaymentIntentCreate, PaymentIntentResponse, Payout
from app.services.auth_service import caretaker_repo
from app.services.travel_service import plan_repo

payment_repo = FirestoreRepository("Payments", Payment, "payment_id")
payout_repo = FirestoreRepository("Payouts", Payout, "payout_id")


def _compute_fee(gross_amount: float) -> tuple[float, float]:
    platform_fee = round(gross_amount * settings.PLATFORM_FEE_PERCENT / 100, 2)
    net_payout_amount = round(gross_amount - platform_fee, 2)
    return platform_fee, net_payout_amount


def _perform_payout(caretaker: Caretaker, amount: float) -> tuple[PayoutStatus, str | None]:
    """
    Executes (or simulates) the actual bank transfer to the caretaker.

    SIMULATION MODE (settings.PAYOUT_SIMULATION_MODE = True, the default):
    No real money moves. Marks the payout TRANSFERRED immediately and records
    a fake gateway id, so the rest of the app (Payment/Payout status, caretaker
    payout history, etc.) behaves exactly as it will once real payouts are live.

    TO GO LIVE: set PAYOUT_SIMULATION_MODE=false in .env once RazorpayX is
    enabled and configured — delete nothing, just flip that one setting.
    """
    if settings.PAYOUT_SIMULATION_MODE:
        simulated_gateway_id = f"SIMULATED-{uuid.uuid4()}"
        return PayoutStatus.TRANSFERRED, simulated_gateway_id

    try:
        result = initiate_payout(
            account_number=caretaker.bank_account_details.account_number,
            ifsc_code=caretaker.bank_account_details.ifsc_code,
            account_holder_name=caretaker.bank_account_details.account_holder_name,
            amount_in_rupees=amount,
        )
        return PayoutStatus.TRANSFERRED, result.get("id")
    except Exception:
        return PayoutStatus.FAILED, None


def create_payment_intent(payload: PaymentIntentCreate) -> PaymentIntentResponse:
    plan = plan_repo.get(payload.plan_id)
    if not plan:
        raise ValueError("Travel plan not found")

    platform_fee, net_payout_amount = _compute_fee(payload.gross_amount)
    payment_id = payment_repo.generate_id()

    order = create_order(payload.gross_amount, payload.currency, receipt=payment_id)

    payment = Payment(
        payment_id=payment_id,
        user_id=payload.user_id,
        plan_id=payload.plan_id,
        gateway_transaction_id=order["id"],
        gross_amount=payload.gross_amount,
        platform_fee=platform_fee,
        net_payout_amount=net_payout_amount,
        payment_status=PaymentStatus.PENDING,
    )
    payment_repo.create(payment)

    return PaymentIntentResponse(
        payment_id=payment_id,
        gateway_order_id=order["id"],
        gateway_key=settings.RAZORPAY_KEY_ID,
        amount=payload.gross_amount,
        currency=payload.currency,
    )


def handle_webhook(raw_body: bytes, signature: str, event: dict) -> None:
    if not verify_webhook_signature(raw_body, signature):
        raise PermissionError("Invalid webhook signature")

    if event.get("event") != "payment.captured":
        return  # ignore events we don't act on (refunds, failures, etc. handled separately if needed)

    order_id = event["payload"]["payment"]["entity"]["order_id"]
    payment = payment_repo.find_one_by("gateway_transaction_id", order_id)
    if not payment:
        raise ValueError(f"No Payment record found for order {order_id}")

    payment_repo.update(
        payment.payment_id,
        {
            "payment_status": PaymentStatus.HELD_IN_ESCROW.value,
            "paid_at": datetime.now(timezone.utc).isoformat(),
        },
    )


def release_payment_and_payout(plan_id: str) -> Payout | None:
    """
    Called by dispatch_service when a booking reaches COMPLETED.
    Idempotent-ish: returns None (no-op) if there's nothing to release,
    so calling this twice for the same plan won't double-pay.
    """
    payment = payment_repo.find_one_by("plan_id", plan_id)
    if not payment:
        return None  # no payment was ever taken for this plan
    if payment.payment_status != PaymentStatus.HELD_IN_ESCROW:
        return None  # already released, refunded, or never escrowed — don't act again

    plan = plan_repo.get(plan_id)
    if not plan or not plan.assigned_caretaker_id:
        raise ValueError("No caretaker assigned to this plan")

    caretaker = caretaker_repo.get(plan.assigned_caretaker_id)
    if not caretaker or not caretaker.bank_account_details:
        raise ValueError("Caretaker has no bank account on file — cannot pay out")

    payout_id = payout_repo.generate_id()
    payout_status, gateway_id = _perform_payout(caretaker, payment.net_payout_amount)

    payout = Payout(
        payout_id=payout_id,
        payment_id=payment.payment_id,
        recipient_id=caretaker.caretaker_id,
        payout_gateway_id=gateway_id,
        amount_transferred=payment.net_payout_amount,
        payout_status=payout_status,
        transferred_at=datetime.now(timezone.utc) if payout_status == PayoutStatus.TRANSFERRED else None,
    )
    payout_repo.create(payout)

    payment_repo.update(
        payment.payment_id,
        {
            "payment_status": (
                PaymentStatus.RELEASED.value if payout_status == PayoutStatus.TRANSFERRED else PaymentStatus.HELD_IN_ESCROW.value
            )
        },
    )

    return payout