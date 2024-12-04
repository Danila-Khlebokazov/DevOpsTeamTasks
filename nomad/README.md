# Nomad Task

## Task #1. Stateful application

Deploy PostgreSQL using Nomad. Configure persistent volumes to retain data.
Use Nomad to periodically back up the database to local or remote location.
Simulate failure and restore the database from backup.

## Task #2. Dynamic port

```python
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
    return JSONResponse({"status": "ok"}, status_code=200)
```

Configure and deploy job that uses dynamic port allocation

## Task #3. Job scaling

Scale the previously deployed service to multiple instances while ensuring minimal
downtime through rolling updates and health checks.

## Task #4. Auto-scaling

Automatically adjust the number of instances based on CPU or memory utilization.
Generate artificial CPU or memory load to trigger the auto-scaling policy.

## Task #5. Manual blue-green deployment without Nomad

Simulate a blue-green deployment for the service above without using HashiCorp
Nomad.
P.S: you could use docker