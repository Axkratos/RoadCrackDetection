from fastapi import FastAPI, Depends
from app.routes import predict
from app.auth import get_current_user, router as auth_router

app = FastAPI()

app.include_router(predict.router)
app.include_router(auth_router)

@app.get("/")
def read_root():
    return {"message": "Welcome to the Anugaman Road Crack Detection API"}

@app.get("/secure-endpoint")
async def secure_endpoint(current_user: str = Depends(get_current_user)):
    return {"message": f"Hello, {current_user['username']}"}