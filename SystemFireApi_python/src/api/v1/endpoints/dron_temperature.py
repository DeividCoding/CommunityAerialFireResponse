from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from api.v1.docs.dron_temperature import (
    create_register_temperature,
    get_register_temperature,
)
from api.v1.schemas.dron_temperature import (
    TemperatureRecordCreateRequestSchema,
    TemperatureRecordRetrieveRequestSchema,
)
from api.v1.services.dron_temperature import (
    ServiceRegisterTemperature,
    ServiceRetrieveTemperature,
)
from core.database import get_session
from core.utils.responses import EnvelopeResponse

router = APIRouter(prefix="/dron-temperature", tags=["Dron temperature"])


@router.post(
    "/",
    **create_register_temperature.as_dict(),
    response_model=EnvelopeResponse,
)
async def create_register_temperature(
    params: TemperatureRecordCreateRequestSchema,
    session: Session = Depends(get_session),
):
    service = ServiceRegisterTemperature(session=session)
    result = service.create(params)
    return result


@router.get(
    "/",
    **get_register_temperature.as_dict(),
    response_model=EnvelopeResponse,
)
async def get_register_temperature(
    params: TemperatureRecordRetrieveRequestSchema = Depends(),
    session: Session = Depends(get_session),
):
    service = ServiceRetrieveTemperature(session=session)
    result = service.retrieve(params)
    return result
