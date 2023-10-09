# Refunds Api Rest
from core.utils.environment import EnvPrefix

from .base import BaseSettings


class TestingSettings(BaseSettings):
    class Config:
        env_prefix = EnvPrefix.TESTING.value
