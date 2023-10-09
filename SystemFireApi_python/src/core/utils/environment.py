from enum import Enum


class Environment(Enum):
    LOCAL = "local"
    DEVELOPMENT = "development"
    STAGING = "staging"
    PRODUCTION = "production"
    TESTING = "testing"

    @classmethod
    def _is_valid_value(cls, value: str) -> bool:
        return value in cls._value2member_map_

    @classmethod
    def _get_valid_values(cls):
        return [member.value for member in cls]

    @classmethod
    def check_value(cls, value: str):
        if not cls._is_valid_value(value):
            raise ValueError(
                f"{value} is not a valid Environment value. Valid values are: {', '.join(cls._get_valid_values())}"
            )


class EnvPrefix(Enum):
    LOCAL = "LOCAL_"
    DEVELOPMENT = "DEV_"
    STAGING = "STG_"
    PRODUCTION = "PROD_"
    TESTING = "TEST_"
