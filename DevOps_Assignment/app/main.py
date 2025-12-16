from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn
from prometheus_fastapi_instrumentator import Instrumentator
from typing import List, Optional
import random

app = FastAPI()

# Instrument the app
Instrumentator().instrument(app).expose(app)

# --- Data Model ---
class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float

# --- In-Memory Database ---
items_db = [
    {"name": "Kubernetes Guide", "description": "A complete guide to K8s", "price": 29.99},
    {"name": "DevOps Handbook", "description": "Learn CI/CD pipelines", "price": 45.50},
    {"name": "Cloud Native Patterns", "description": "Architecting for the cloud", "price": 35.00},
    {"name": "Prometheus Up & Running", "description": "Monitoring for the masses", "price": 50.00}
]

# --- Endpoints ---

@app.get("/")
def read_root():
    return {"message": "Welcome to the DevOps Assignment App! The API is running."}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/items", response_model=List[Item])
def get_items():
    return items_db

@app.post("/items", response_model=Item)
def create_item(item: Item):
    items_db.append(item)
    return item

@app.get("/predict")
def predict():
    # Simulate some random prediction logic
    return {"score": random.uniform(0.1, 0.9)}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
