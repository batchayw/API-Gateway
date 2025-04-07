from fastapi import APIRouter, Depends, HTTPException # type: ignore
from typing import List
from .models import Patient, MedicalRecord, AcademicHistory
from .database import get_db
from .services import (
    get_patient_info,
    get_medical_history,
    get_academic_history,
    validate_nss_format
)
from .security import DataEncryptor # type: ignore

router = APIRouter()
encryptor = DataEncryptor()

@router.get("/patient/{nss}", response_model=dict)
async def read_patient(nss: str, db=Depends(get_db)):
    """Endpoint principal pour récupérer les informations d'un patient"""
    try:
        # Validation du format NSS
        if not validate_nss_format(nss):
            raise HTTPException(status_code=400, detail="Format NSS invalide")
        
        # Récupération des données
        patient_data = get_patient_info(nss, db)
        
        # Chiffrement des données sensibles avant retour
        patient_data["personal_info"]["nss"] = encryptor.hash_sensitive_data(nss)
        
        return patient_data
    except Exception as e:
        raise HTTPException(status_code=404, detail=str(e))

@router.get("/patient/{nss}/medical", response_model=List[dict])
async def read_medical_history(nss: str, year: int = None, db=Depends(get_db)):
    """Endpoint pour l'historique médical"""
    validate_nss_format(nss)
    return get_medical_history(nss, year, db)

@router.get("/patient/{nss}/academic", response_model=List[dict])
async def read_academic_history(nss: str, degree: str = None, db=Depends(get_db)):
    """Endpoint pour le parcours académique"""
    validate_nss_format(nss)
    return get_academic_history(nss, degree, db)

@router.get("/search")
async def search_patients(
    first_name: str = None,
    last_name: str = None,
    birth_year: int = None,
    db=Depends(get_db)
):
    """Endpoint de recherche avec filtres"""
    # Implémentation de la recherche serait ici
    return {"message": "Fonctionnalité en développement"}