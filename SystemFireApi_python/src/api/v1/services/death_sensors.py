from api.v1.schemas.death_sensors import (
    DeathSensorSchema,
    DeathSensorUpdateRequestSchema,
)
from core.utils.responses import EnvelopeResponse
from models.death_sensors import DeathSensors
from repository.death_sensors import RepositoryDeathSensors


class ServiceDeathSensors:
    def __init__(self, session):
        self.session = session
        self.repository = RepositoryDeathSensors(session)

    def retrieve(self):
        pass


class ServiceListSensors:
    def __init__(self, session):
        self.session = session
        self.repository = RepositoryDeathSensors(session)

    def list(self):
        all_sensors = self.session.query(DeathSensors).all()
        list_sensor_death_schema = []
        for death_sensor in all_sensors:
            register_schema = DeathSensorSchema(
                latitude=death_sensor.latitude,
                longitude=death_sensor.longitude,
                datetime_event=death_sensor.datetime_event,
                temperature=death_sensor.temperature,
                battery_percentage=death_sensor.battery_percentage,
                is_dead=death_sensor.is_dead,
            )
            list_sensor_death_schema.append(register_schema)

        response = EnvelopeResponse(
            Message="List all deadth sensors", Data=list_sensor_death_schema
        )
        return response


class ServiceUpdateDeathSensors:
    def __init__(self, session):
        self.session = session
        self.repository = RepositoryDeathSensors(session)

    def update(self, request: DeathSensorUpdateRequestSchema):
        death_sensor = (
            self.session.query(DeathSensors)
            .filter(
                DeathSensors.latitude == request.latitude,
                DeathSensors.longitude == request.longitude,
            )
            .first()
        )
        if death_sensor:
            death_sensor.is_dead = request.is_dead
            self.session.commit()
            register_schema = DeathSensorSchema(
                latitude=death_sensor.latitude,
                longitude=death_sensor.longitude,
                datetime_event=death_sensor.datetime_event,
                temperature=death_sensor.temperature,
                battery_percentage=death_sensor.battery_percentage,
                is_dead=death_sensor.is_dead,
            )

            response = EnvelopeResponse(
                Message="Update death sensor with success", Data=register_schema
            )

        else:
            response = EnvelopeResponse(
                Message=f"No fount death sensor with latitude:{request.latitude} and longitude:{request.longitude}"
            )

        return response
