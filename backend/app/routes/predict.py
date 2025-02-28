from fastapi import APIRouter, File, UploadFile
from fastapi.responses import JSONResponse
from app.utils.image_processing import process_image
from app.models.densenet161 import load_model, predict_crack

router = APIRouter()

model = load_model()

@router.post("/predict")
async def predict(file: UploadFile = File(...)):
    image = await file.read()
    processed_image = process_image(image)
    prediction = predict_crack(model, processed_image)
    return JSONResponse(content={"prediction": prediction})