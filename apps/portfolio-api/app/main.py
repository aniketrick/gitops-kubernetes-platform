from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime, timezone

app = FastAPI(title="Portfolio API", version="1.0.0")

class StatusResponse(BaseModel):
    status: str
    service: str
    timestamp: str

@app.get("/")
def root():
    return {
        "message": "GitOps Kubernetes Platform is running",
        "docs": "/docs"
    }

@app.get("/health", response_model=StatusResponse)
def health():
    return StatusResponse(
        status="healthy",
        service="portfolio-api",
        timestamp=datetime.now(timezone.utc).isoformat()
    )

@app.get("/version")
def version():
    return {
        "version": "1.0.0",
        "deployment": "managed-by-argocd",
        "platform": "kubernetes"
    }
