from datetime import datetime

from sqlalchemy import asc, func

from models.temperature_records import TemperatureRecords

from .base import RepositoryBase


class RepositoryTemperatureRecords(RepositoryBase):
    model = TemperatureRecords

    def get_next_closest_record(self, datetime_event: datetime):
        record = (
            self.session.query(TemperatureRecords)
            .filter(TemperatureRecords.datetime_event > datetime_event)
            .order_by(asc(TemperatureRecords.datetime_event))
            .first()
        )

        return record
