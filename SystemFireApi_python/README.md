# DRON TEMPERATURE


## 1) Ejecutar la aplicacion

```shell
uvicorn main:app --reload --port 7899
```

## 2) Configuracion de migraciones

* Creara carpeta llamada alembic
    ```shell
    alembic init alembic
    ```

* Crear la migracion
    ```shell
    alembic revision --autogenerate -m "init"
    ```

* Ejecutar la migracion
    ```shell
    alembic upgrade head
    ```

* Fuentes de informacion:

    * https://medium.com/@julgq/migraciones-en-fastapi-usando-alembic-19379607db70
