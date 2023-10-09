FROM python:3.11-alpine
RUN pip install -U poetry gunicorn uvicorn[standard]
RUN apk add --no-cache git
WORKDIR /app
COPY ./requirements/production.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY ./src /app
EXPOSE 9000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "9000", "--workers", "2"]
