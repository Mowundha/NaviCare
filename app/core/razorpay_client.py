"""
Razorpay integration for payment intents (orders), webhook signature
verification, and payouts.

IMPORTANT — payouts require RazorpayX, not standard Razorpay Payments:
Creating an order (money coming IN from the user) works with your normal
Razorpay Key ID/Secret. Actually transferring money OUT to a caretaker's
bank account is a DIFFERENT product — RazorpayX — with its own signup, KYC,
and API credentials, plus a one-time "fund account" linking step per
caretaker before you can pay them. initiate_payout() below is a placeholder
until you have RazorpayX enabled; wire in the real call then.
"""
import hashlib
import hmac

import razorpay

from app.core.config import settings

_client: razorpay.Client | None = None


def get_client() -> razorpay.Client:
    global _client
    if _client is None:
        _client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET))
    return _client


def create_order(amount_in_rupees: float, currency: str, receipt: str) -> dict:
    """Razorpay wants the amount in the smallest currency unit (paise for INR)."""
    client = get_client()
    return client.order.create(
        {
            "amount": int(round(amount_in_rupees * 100)),
            "currency": currency,
            "receipt": receipt,
            "payment_capture": 1,
        }
    )


def verify_webhook_signature(raw_body: bytes, signature: str) -> bool:
    expected = hmac.new(settings.RAZORPAY_WEBHOOK_SECRET.encode("utf-8"), raw_body, hashlib.sha256).hexdigest()
    return hmac.compare_digest(expected, signature)


def initiate_payout(account_number: str, ifsc_code: str, account_holder_name: str, amount_in_rupees: float) -> dict:
    """
    PLACEHOLDER — requires RazorpayX (separate product/credentials from
    standard Razorpay Payments), plus a fund_account linking step done once
    per caretaker beforehand. Replace this function's body once RazorpayX
    access is set up; nothing else in payment_service.py needs to change.
    """
    raise NotImplementedError(
        "RazorpayX payout integration not yet configured. Enable RazorpayX on your "
        "Razorpay account, link a fund_account for the caretaker, then implement the "
        "real payout call here."
    )