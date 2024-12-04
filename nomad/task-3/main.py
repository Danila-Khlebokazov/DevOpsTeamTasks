import os
from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI()
port = os.getenv("PORT", "8000")


@app.get("/")
def read_root():
    return {"message": "Welcome to API!", "port": port}


@app.get("/health")
def is_healthy():
    raise Exception("This is an exception")
    return JSONResponse({"status": "ok"}, status_code=200)
