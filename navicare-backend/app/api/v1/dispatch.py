from fastapi import APIRouter, Depends, HTTPException, WebSocket, WebSocketDisconnect, status

from app.api.deps import AuthContext, get_current_auth
from app.core.security import Role
from app.models.dispatch import DispatchRequest, DispatchStateResponse, DispatchStatusUpdate
from app.services import dispatch_service
from app.services.ws_manager import manager

router = APIRouter()


@router.post("/request", response_model=DispatchStateResponse, status_code=status.HTTP_201_CREATED)
async def request_caretaker(payload: DispatchRequest, auth: AuthContext = Depends(get_current_auth)):
    if auth.role != Role.USER:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only users can request a caretaker")

    try:
        plan = dispatch_service.request_caretaker(payload.plan_id, payload.caretaker_id, auth.subject_id)
    except PermissionError as e:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail=str(e))
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

    await manager.broadcast(plan.plan_id, {"plan_id": plan.plan_id, "dispatch_status": plan.dispatch_status})
    return DispatchStateResponse(
        plan_id=plan.plan_id, assigned_caretaker_id=plan.assigned_caretaker_id, dispatch_status=plan.dispatch_status
    )


@router.post("/{plan_id}/transition", response_model=DispatchStateResponse)
async def transition_status(plan_id: str, payload: DispatchStatusUpdate, auth: AuthContext = Depends(get_current_auth)):
    try:
        plan = dispatch_service.transition(plan_id, auth.role.value, auth.subject_id, payload.new_status)
    except PermissionError as e:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail=str(e))
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

    await manager.broadcast(plan.plan_id, {"plan_id": plan.plan_id, "dispatch_status": plan.dispatch_status})
    return DispatchStateResponse(
        plan_id=plan.plan_id, assigned_caretaker_id=plan.assigned_caretaker_id, dispatch_status=plan.dispatch_status
    )


@router.get("/{plan_id}", response_model=DispatchStateResponse)
def get_dispatch_state(plan_id: str, auth: AuthContext = Depends(get_current_auth)):
    try:
        plan = dispatch_service.get_dispatch_state(plan_id)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))

    return DispatchStateResponse(
        plan_id=plan.plan_id, assigned_caretaker_id=plan.assigned_caretaker_id, dispatch_status=plan.dispatch_status
    )


@router.websocket("/ws/{plan_id}")
async def dispatch_websocket(websocket: WebSocket, plan_id: str):
    """
    Optional convenience channel — see the LIMITATION note in ws_manager.py.
    Client connects here to get pushed dispatch_status updates without polling.
    """
    await manager.connect(plan_id, websocket)
    try:
        while True:
            await websocket.receive_text()  # keep the connection alive; client doesn't need to send anything meaningful
    except WebSocketDisconnect:
        manager.disconnect(plan_id, websocket)