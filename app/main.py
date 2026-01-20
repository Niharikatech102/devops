from fastapi import FastAPI
import os

app = FastAPI()

@app.get("/")
def read_root():
    return {
        "message": "Hello from AWS ECS Fargate!",
        "environment": os.environ.get("ENVIRONMENT", "local"),
        "version": "1.0.0"
    }

@app.get("/health")
def read_health():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
