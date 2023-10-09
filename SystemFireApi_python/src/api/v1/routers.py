# Third Party Stuff
from fastapi import APIRouter

from api.v1.endpoints.death_sensors import router as death_sensor_router
from api.v1.endpoints.dron_temperature import router as dron_temperature_router
from api.v1.endpoints.health import router as health

api_health_router = APIRouter()
api_health_router.include_router(health, tags=["health"])

api_v1_router = APIRouter()
api_v1_router.include_router(dron_temperature_router)
api_v1_router.include_router(death_sensor_router)
