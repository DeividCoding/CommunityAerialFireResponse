from datetime import datetime

from pydantic import BaseModel

from core.settings import settings


class DeathSensorUpdateRequestSchema(BaseModel):
    latitude: float
    longitude: float
    is_dead: bool


class DeathSensorSchema(BaseModel):
    latitude: float
    longitude: float
    datetime_event: datetime
    temperature: float
    battery_percentage: float
    is_dead: bool

    class Config:
        json_encoders = {datetime: lambda dt: dt.strftime(settings.DATETIME_FORMAT)}
