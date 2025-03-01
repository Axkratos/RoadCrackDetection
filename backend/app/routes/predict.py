from fastapi import APIRouter, File, UploadFile, HTTPException, Depends
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from app.utils.image_processing import process_image
from app.models.densenet161 import load_model, predict_crack
from app.database import SessionLocal, ImagePrediction

router = APIRouter()

model = load_model()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/predict")
async def predict(file: UploadFile = File(...), db: Session = Depends(get_db)):
    try:
        image = await file.read()
        processed_image = process_image(image)
        prediction = predict_crack(model, processed_image)
        
        # Save prediction to the database
        db_prediction = ImagePrediction(filename=file.filename, prediction=str(prediction))
        db.add(db_prediction)
        db.commit()
        db.refresh(db_prediction)
        
        return JSONResponse(content={"prediction": prediction})
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))