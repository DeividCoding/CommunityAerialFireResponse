# Refunds Api Rest
from core.utils.environment import EnvPrefix

from .base import BaseSettings


class DevelopmentSettings(BaseSettings):
    class Config:
        env_prefix = EnvPrefix.DEVELOPMENT.value
