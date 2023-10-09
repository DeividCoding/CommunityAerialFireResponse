from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse

from api.v1.routers import api_health_router, api_v1_router
from core.catcher import CatcherExceptionsMiddleware
from core.settings import settings
from core.utils.validations import validation_pydantic_field

app = FastAPI(
    title=settings.PROJECT_NAME,
    redirect_slashes=False,
)


# Set all CORS enabled origins
app.add_middleware(CatcherExceptionsMiddleware)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_v1_router, prefix=settings.API_V1)
app.include_router(api_health_router)


@app.get("/", include_in_schema=False)
def root():
    return RedirectResponse(url="/docs")


validation_pydantic_field(app)
