from sqlalchemy import asc, func

from models.death_sensors import DeathSensors

from .base import RepositoryBase


class RepositoryDeathSensors(RepositoryBase):
    model = DeathSensors
