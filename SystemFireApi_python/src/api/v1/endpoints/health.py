from fastapi import APIRouter, status

from api.v1.schemas.health_schema import HealthModel
from core.utils.responses import EnvelopeResponse

router = APIRouter()


@router.get(
    "/health",
    status_code=status.HTTP_200_OK,
    summary="Health check service",
)
async def health_check():
    result = HealthModel(status="ok")
    return result
