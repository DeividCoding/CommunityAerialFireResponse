from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from api.v1.docs.dron_temperature import create_register_temperature
from api.v1.schemas.death_sensors import DeathSensorUpdateRequestSchema
from api.v1.services.death_sensors import ServiceListSensors, ServiceUpdateDeathSensors
from core.database import get_session
from core.utils.responses import EnvelopeResponse

router = APIRouter(prefix="/deadth-sensor", tags=["Death sensors"])


@router.get(
    "/all",
    **create_register_temperature.as_dict(),
    response_model=EnvelopeResponse,
)
async def create_death_sensors(
    session: Session = Depends(get_session),
):
    service = ServiceListSensors(session=session)
    result = service.list()
    return result


@router.patch(
    "/",
    **create_register_temperature.as_dict(),
    response_model=EnvelopeResponse,
)
async def update_death_sensors(
    params: DeathSensorUpdateRequestSchema,
    session: Session = Depends(get_session),
):
    service = ServiceUpdateDeathSensors(session=session)
    result = service.update(params)
    return result
