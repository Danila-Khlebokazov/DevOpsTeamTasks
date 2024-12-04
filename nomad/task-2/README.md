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


## Usage

Just run the job under nomad
```bash
nomad job run deploy-dynamic.nomad
```

