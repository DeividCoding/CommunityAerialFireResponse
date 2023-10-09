from datetime import datetime
from typing import List

from pydantic import BaseModel

from core.settings import settings


class TemperatureRecordCreateRequestSchema(BaseModel):
    latitude: float
    longitude: float
    datetime_event: datetime
    temperatures: List[int]


class TemperatureRecordRetrieveRequestSchema(BaseModel):
    datetime_event: datetime


class TemperatureRecordSchema(BaseModel):
    latitude: float
    longitude: float
    datetime_event: datetime
    temperatures: List[int]

    class Config:
        json_encoders = {datetime: lambda dt: dt.strftime(settings.DATETIME_FORMAT)}
