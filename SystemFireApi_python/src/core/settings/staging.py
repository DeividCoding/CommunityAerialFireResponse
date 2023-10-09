# Refunds Api Rest
from core.utils.environment import EnvPrefix

from .base import BaseSettings


class StagingSettings(BaseSettings):
    class Config:
        env_prefix = EnvPrefix.STAGING.value
