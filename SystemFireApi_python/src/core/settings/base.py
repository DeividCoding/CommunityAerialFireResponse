# Standard Library
import os
from pathlib import Path
from typing import List

# Third Party Stuff
from dotenv import load_dotenv
from pydantic import PostgresDsn
from pydantic_settings import BaseSettings as PydanticSettings
from pydantic_settings import SettingsConfigDict

from ..utils.environment import Environment

BASE_DIR = Path(__file__).resolve().parent.parent.parent
ENV_FILE_PATH = os.path.join(BASE_DIR, "core", "settings", ".env")
load_dotenv(ENV_FILE_PATH)

ENVIRONMENT = os.environ.get("ENVIRONMENT")
Environment.check_value(ENVIRONMENT)


class BaseSettings(PydanticSettings):
    model_config = SettingsConfigDict(
        env_file=ENV_FILE_PATH, extra="ignore", case_sensitive=True
    )

    DATABASE_URL: str
    CORS_ORIGINS: List = ["*"]

    ENVIRONMENT: Environment = ENVIRONMENT
    TIME_ZONE: str = "utc"
    PROJECT_NAME: str = "Dron temperature api"
    DATETIME_FORMAT: str = "%Y-%m-%d %H:%M:%S"
    DATE_FORMAT: str = "%Y-%m-%d"
    API_V1: str = "/api/v1"
