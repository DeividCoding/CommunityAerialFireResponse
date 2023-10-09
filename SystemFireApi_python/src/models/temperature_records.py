from sqlalchemy import Column, DateTime, Float, Integer
from sqlalchemy.dialects.postgresql import ARRAY

from .base_model import BaseModelClass


class TemperatureRecords(BaseModelClass):
    __tablename__ = "temperature_records"

    id = Column(Integer, primary_key=True)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    datetime_event = Column(DateTime, nullable=False)
    temperatures = Column(ARRAY(Integer), nullable=False)
