"""
Minimal in-memory WebSocket broadcaster, keyed by plan_id.

LIMITATION: this only works within a single Cloud Run instance. If Cloud Run
scales to multiple instances, a client connected to instance A won't receive
a broadcast triggered by a request handled on instance B. Fine for early
development/demo; for production-scale real-time updates, prefer having the
Flutter app listen directly to the Travel_Plans document via the Firestore
client SDK's real-time listeners (onSnapshot) instead of this — Firestore
listeners work correctly regardless of how many backend instances are running,
since they don't go through this backend at all.
"""
from fastapi import WebSocket


class DispatchConnectionManager:
    def __init__(self):
        self._connections: dict[str, list[WebSocket]] = {}

    async def connect(self, plan_id: str, websocket: WebSocket):
        await websocket.accept()
        self._connections.setdefault(plan_id, []).append(websocket)

    def disconnect(self, plan_id: str, websocket: WebSocket):
        if plan_id in self._connections and websocket in self._connections[plan_id]:
            self._connections[plan_id].remove(websocket)
            if not self._connections[plan_id]:
                del self._connections[plan_id]

    async def broadcast(self, plan_id: str, message: dict):
        for ws in self._connections.get(plan_id, []):
            try:
                await ws.send_json(message)
            except Exception:
                pass  # stale connection; will be cleaned up on next disconnect event


manager = DispatchConnectionManager()