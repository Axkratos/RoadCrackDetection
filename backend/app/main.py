from fastapi import FastAPI
from app.routes import predict

app = FastAPI()

app.include_router(predict.router)

@app.get("/")
def read_root():
    return {"message": "Welcome to the Anugaman Road Crack Detection API"}