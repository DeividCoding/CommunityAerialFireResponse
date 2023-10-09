# Standard Library
import logging
from logging.config import dictConfig

from pydantic import BaseModel

from core.settings.base import ENVIRONMENT, BaseSettings, Environment
from core.settings.development import DevelopmentSettings
from core.settings.local import LocalSettings
from core.settings.production import ProductionSettings
from core.settings.testing import TestingSettings


class LogConfig(BaseModel):
    # LOGGER_NAME: str = ""
    LOG_FORMAT: str = "%(levelprefix)s \033[36m\033[1m[%(asctime)s | %(name)s:%(lineno)d]: \033[0m%(message)s"
    LOG_LEVEL: str = "DEBUG"

    # Logging config
    version: int = 1
    disable_existing_loggers: bool = False
    formatters: dict = {
        "default": {
            "()": "uvicorn.logging.DefaultFormatter",
            "fmt": LOG_FORMAT,
            "datefmt": "%Y-%m-%d %H:%M:%S",
        },
    }
    handlers: dict = {
        "default": {
            "formatter": "default",
            "class": "logging.StreamHandler",
            "stream": "ext://sys.stderr",
        },
    }
    loggers: dict = {
        "": {"handlers": ["default"], "level": LOG_LEVEL},
    }


class SettingsManager:
    def __init__(self, environment):
        self.environment = environment
        self.settings = self._get_settings()
        self._do_actions()

    def _do_actions(self):
        if self.environment == Environment.LOCAL:
            pass
        elif self.environment == Environment.DEVELOPMENT:
            pass
        elif self.environment == Environment.PRODUCTION:
            pass
        elif self.environment == Environment.TESTING:
            pass

    def _get_settings(self):
        env = self.environment
        settings_class_dict = {
            Environment.LOCAL.value: LocalSettings,
            Environment.DEVELOPMENT.value: DevelopmentSettings,
            Environment.PRODUCTION.value: ProductionSettings,
            Environment.TESTING.value: TestingSettings,
        }
        try:
            settings_class = settings_class_dict[env]
        except KeyError:
            raise ValueError(f"Unrecognized environment value: {env}")
        settings: BaseSettings = settings_class()
        return settings


settings: BaseSettings = SettingsManager(environment=ENVIRONMENT).settings

log_config_dict = LogConfig().__dict__
dictConfig(LogConfig().dict())
log = logging.getLogger(__name__)
settings: BaseSettings = SettingsManager(environment=ENVIRONMENT).settings
