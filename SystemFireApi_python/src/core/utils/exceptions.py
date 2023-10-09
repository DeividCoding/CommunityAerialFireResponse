from fastapi import status


class BaseAppException(Exception):
    error_key = None  # Class variable that can be overwritten by subclasses
    status_code = status.HTTP_400_BAD_REQUEST

    def __init__(self, message):
        super().__init__(message)
        # If error_key isn't defined, use the class name
        self.error_name = self.error_key or self.__class__.__name__
        self.message = message

    def to_dict(self):
        return {self.error_name: str(self.message)}

    def __str__(self):
        return str(self.to_dict())


class FormException(BaseAppException):
    error_key = "FormError"
    status_code = status.HTTP_400_BAD_REQUEST

    def __init__(self, field_errors: dict = None) -> None:
        self.field_errors = field_errors or {}

    def to_dict(self):
        return {error: value for error, value in self.field_errors.items() if value}


class DataBaseException(BaseAppException):
    error_key = "DataBaseError"
    status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
