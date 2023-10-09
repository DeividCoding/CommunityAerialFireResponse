from datetime import datetime
from typing import Any, Union

from pydantic import BaseModel, HttpUrl
from pytz import timezone

from core.settings import settings


class EnvelopeResponse(BaseModel):
    Success: bool = True
    Message: Union[Any, None] = None
    Data: Union[Any, None] = None


def format_datetime_to_app_standard(dt: datetime) -> str:
    return dt.strftime(settings.DATETIME_FORMAT)


def get_current_date_time_to_app_standard() -> datetime:
    return datetime.now(timezone(settings.TIME_ZONE))
