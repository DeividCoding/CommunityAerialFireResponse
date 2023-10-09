# Refunds Api Rest
from core.utils.environment import EnvPrefix

from .base import BaseSettings


class ProductionSettings(BaseSettings):
    class Config:
        env_prefix = EnvPrefix.PRODUCTION.value
