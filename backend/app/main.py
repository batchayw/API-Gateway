from fastapi import FastAPI, HTTPException # type: ignore
from pydantic import BaseModel # type: ignore
from typing import List, Optional
import databases # type: ignore
import sqlalchemy # type: ignore
from .database import get_db
from .models import Patient, MedicalRecord, AcademicHistory
from .services import get_patient_info

app = FastAPI()

DATABASE_URL = "postgresql://user:password@postgres-service:5432/medical_db"
database = databases.Database(DATABASE_URL)
metadata = sqlalchemy.MetaData()

@app.on_event("startup")
async def startup():
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

class PatientResponse(BaseModel):
    personal_info: dict
    medical_history: List[dict]
    academic_history: List[dict]
    addresses: List[dict]
    phone_numbers: List[dict]

@app.get("/api/patient/{nss}", response_model=PatientResponse)
async def get_patient(nss: str):
    try:
        return await get_patient_info(nss, database)
    except Exception as e:
        raise HTTPException(status_code=404, detail=str(e))

@app.get("/health")
async def health_check():
    return {"status": "healthy"}