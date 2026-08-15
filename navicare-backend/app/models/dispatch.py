from pydantic import BaseModel

from app.models.enums import DispatchStatus


class DispatchRequest(BaseModel):
    plan_id: str
    caretaker_id: str


class DispatchStatusUpdate(BaseModel):
    new_status: DispatchStatus


class DispatchStateResponse(BaseModel):
    plan_id: str
    assigned_caretaker_id: str | None
    dispatch_status: DispatchStatus | None