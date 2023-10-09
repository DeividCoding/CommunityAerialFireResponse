from sqlalchemy import Boolean, Column, DateTime, Float, Integer
from sqlalchemy.dialects.postgresql import ARRAY

from .base_model import BaseModelClass


class DeathSensors(BaseModelClass):
    __tablename__ = "death_sensors"

    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    datetime_event = Column(DateTime, nullable=False)
    temperature = Column(Float, nullable=False)
    battery_percentage = Column(Float, nullable=False)
    is_dead = Column(Boolean, default=False)
