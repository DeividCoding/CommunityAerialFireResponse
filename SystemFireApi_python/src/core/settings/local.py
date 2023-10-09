# Refunds Api Rest
from core.utils.environment import EnvPrefix

from .base import BaseSettings


class LocalSettings(BaseSettings):
    class Config:
        env_prefix = EnvPrefix.LOCAL.value
