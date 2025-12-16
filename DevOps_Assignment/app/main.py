from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn

app = FastAPI()

class PredictionResponse(BaseModel):
    score: float

@app.get("/")
def read_root():
    return {"message": "Welcome to the DevOps Assignment App! The API is running."}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/predict", response_model=PredictionResponse)
def predict():
    return {"score": 0.75}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
