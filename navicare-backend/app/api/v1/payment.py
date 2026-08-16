import json

from fastapi import APIRouter, Depends, HTTPException, Request, status

from app.api.deps import AuthContext, require_user
from app.models.payment import Payment, PaymentIntentCreate, PaymentIntentResponse
from app.services import payment_service

router = APIRouter()


@router.post("/create-intent", response_model=PaymentIntentResponse, status_code=status.HTTP_201_CREATED)
def create_intent(payload: PaymentIntentCreate, auth: AuthContext = Depends(require_user)):
    if payload.user_id != auth.subject_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Cannot create a payment for another user")

    try:
        return payment_service.create_payment_intent(payload)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.post("/webhook", status_code=status.HTTP_200_OK)
async def razorpay_webhook(request: Request):
    """
    No auth dependency — Razorpay calls this directly. Trust is established
    via the signature check inside handle_webhook(), not a bearer token.
    """
    raw_body = await request.body()
    signature = request.headers.get("X-Razorpay-Signature", "")
    event = json.loads(raw_body)

    try:
        payment_service.handle_webhook(raw_body, signature, event)
    except PermissionError:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid webhook signature")
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))

    return {"status": "ok"}


@router.get("/{payment_id}", response_model=Payment)
def get_payment(payment_id: str, auth: AuthContext = Depends(require_user)):
    payment = payment_service.payment_repo.get(payment_id)
    if not payment:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Payment not found")
    if payment.user_id != auth.subject_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not your payment")
    return payment