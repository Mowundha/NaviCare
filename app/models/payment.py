from datetime import datetime, timezone

from pydantic import BaseModel, Field

from app.models.enums import PaymentStatus, PayoutStatus


class Payment(BaseModel):
    payment_id: str
    user_id: str
    plan_id: str
    gateway_transaction_id: str | None = None
    gross_amount: float
    platform_fee: float = 0.0
    net_payout_amount: float = 0.0
    payment_status: PaymentStatus = PaymentStatus.PENDING
    paid_at: datetime | None = None


class PaymentIntentCreate(BaseModel):
    user_id: str
    plan_id: str
    gross_amount: float
    currency: str = "INR"
    payment_method: str = "upi"  # 'upi' | 'gpay' | 'card'


class PaymentIntentResponse(BaseModel):
    payment_id: str
    gateway_order_id: str
    gateway_key: str  # public key the client SDK needs (Razorpay key_id)
    amount: float
    currency: str


class Payout(BaseModel):
    payout_id: str
    payment_id: str
    recipient_id: str  # caretaker_id
    payout_gateway_id: str | None = None
    amount_transferred: float
    payout_status: PayoutStatus = PayoutStatus.PROCESSING
    transferred_at: datetime | None = Field(default=None)
