from sqlalchemy.orm import Session # type: ignore
from .models import Patient, MedicalRecord, AcademicHistory
from datetime import datetime
import re
from typing import List, Optional, Dict
from .models import Address, PhoneNumber

def validate_nss_format(nss: str) -> bool:
    """Valide le format du numéro de sécurité sociale"""
    return re.match(r'^\d{13}$', nss) is not None

async def get_patient_info(nss: str, db: Session) -> Dict:
    """Récupère toutes les informations d'un patient"""
    patient = db.query(Patient).filter(Patient.nss == nss).first()
    if not patient:
        raise Exception("Patient non trouvé")
    
    return {
        "personal_info": {
            "first_name": patient.first_name,
            "last_name": patient.last_name,
            "birth_date": patient.birth_date.isoformat(),
            "gender": patient.gender,
            "nationality": patient.nationality,
            "height": patient.height,
            "weight": patient.weight
        },
        "medical_history": get_medical_history(nss, None, db),
        "academic_history": get_academic_history(nss, None, db),
        "addresses": get_addresses(nss, db),
        "phone_numbers": get_phone_numbers(nss, db)
    }

def get_addresses(nss: str, db: Session) -> List[Dict]:
    """Récupère les adresses du patient"""
    addresses = db.query(Address).join(Patient).filter(Patient.nss == nss).all()
    return [{
        "street": addr.street,
        "city": addr.city,
        "postal_code": addr.postal_code,
        "country": addr.country,
        "is_current": addr.is_current,
        "start_date": addr.start_date.isoformat() if addr.start_date else None,
        "end_date": addr.end_date.isoformat() if addr.end_date else None
    } for addr in addresses]

def get_phone_numbers(nss: str, db: Session) -> List[Dict]:
    """Récupère les numéros de téléphone du patient"""
    phones = db.query(PhoneNumber).join(Patient).filter(Patient.nss == nss).all()
    return [{
        "number": phone.number,
        "type": phone.type,
        "is_primary": phone.is_primary,
        "country_code": phone.country_code
    } for phone in phones]

def get_medical_history(nss: str, year: Optional[int], db: Session) -> List[Dict]:
    """Récupère l'historique médical avec filtrage par année"""
    query = db.query(MedicalRecord).join(Patient).filter(Patient.nss == nss)
    
    if year:
        query = query.filter(MedicalRecord.date >= datetime(year, 1, 1),
                             MedicalRecord.date <= datetime(year, 12, 31))
    
    records = query.all()
    return [{
        "record_type": record.record_type,
        "description": record.description,
        "date": record.date.isoformat(),
        "location": record.location,
        "treatment": record.treatment
    } for record in records]

def get_academic_history(nss: str, degree: Optional[str], db: Session) -> List[Dict]:
    """Récupère le parcours académique avec filtrage par diplôme"""
    query = db.query(AcademicHistory).join(Patient).filter(Patient.nss == nss)
    
    if degree:
        query = query.filter(AcademicHistory.degree.ilike(f"%{degree}%"))
    
    history = query.order_by(AcademicHistory.start_year).all()
    return [{
        "degree": item.degree,
        "institution": item.institution,
        "start_year": item.start_year,
        "end_year": item.end_year,
        "country": item.country,
        "city": item.city,
        "average": item.average
    } for item in history]