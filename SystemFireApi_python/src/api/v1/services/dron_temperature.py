from api.v1.schemas.dron_temperature import (
    TemperatureRecordCreateRequestSchema,
    TemperatureRecordRetrieveRequestSchema,
    TemperatureRecordSchema,
)
from core.settings import settings
from core.utils.responses import EnvelopeResponse
from repository.temperature_records import RepositoryTemperatureRecords


class ServiceRetrieveTemperature:
    def __init__(self, session):
        self.session = session
        self.repository = RepositoryTemperatureRecords(session)

    def retrieve(self, request: TemperatureRecordRetrieveRequestSchema):
        temperature_register = self.repository.get_next_closest_record(
            request.datetime_event
        )
        data_response = None
        if temperature_register:
            data_response = TemperatureRecordSchema(
                latitude=temperature_register.latitude,
                longitude=temperature_register.longitude,
                datetime_event=temperature_register.datetime_event,
                temperatures=temperature_register.temperatures,
            )
        response = EnvelopeResponse(Data=data_response)
        return response


class ServiceRegisterTemperature:
    def __init__(self, session):
        self.session = session
        self.repository = RepositoryTemperatureRecords(session)

    def create(self, request: TemperatureRecordCreateRequestSchema):
        self.repository.add(
            latitude=request.latitude,
            longitude=request.longitude,
            datetime_event=request.datetime_event,
            temperatures=request.temperatures,
        )
        register_schema = TemperatureRecordSchema(
            latitude=request.latitude,
            longitude=request.longitude,
            datetime_event=request.datetime_event,
            temperatures=request.temperatures,
        )

        response = EnvelopeResponse(
            Message="Register temperature created success", Data=register_schema
        )
        return response
