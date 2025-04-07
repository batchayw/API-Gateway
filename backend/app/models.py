from sqlalchemy import Column, Integer, String, ForeignKey, Date, Float, Boolean # type: ignore
from sqlalchemy.orm import relationship # type: ignore
from .database import Base

class Patient(Base):
    __tablename__ = "patients"
    
    id = Column(Integer, primary_key=True, index=True)
    nss = Column(String(13), unique=True, index=True)
    first_name = Column(String)
    last_name = Column(String)
    birth_date = Column(Date)
    gender = Column(String)
    nationality = Column(String)
    height = Column(Float)
    weight = Column(Float)
    
    medical_records = relationship("MedicalRecord", back_populates="patient")
    academic_history = relationship("AcademicHistory", back_populates="patient")
    addresses = relationship("Address", back_populates="patient")
    phone_numbers = relationship("PhoneNumber", back_populates="patient")

class MedicalRecord(Base):
    __tablename__ = "medical_records"
    
    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("patients.id"))
    record_type = Column(String)
    description = Column(String)
    date = Column(Date)
    location = Column(String)
    treatment = Column(String)
    
    patient = relationship("Patient", back_populates="medical_records")

class AcademicHistory(Base):
    __tablename__ = "academic_history"
    
    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("patients.id"))
    degree = Column(String)
    institution = Column(String)
    start_year = Column(Integer)
    end_year = Column(Integer)
    country = Column(String)
    city = Column(String)
    average = Column(Float)
    
    patient = relationship("Patient", back_populates="academic_history")

class Address(Base):
    __tablename__ = "addresses"
    
    id = Column(Integer, primary_key=True)
    patient_id = Column(Integer, ForeignKey("patients.id"))
    street = Column(String)
    city = Column(String)
    postal_code = Column(String)
    country = Column(String)
    is_current = Column(Boolean, default=True)
    start_date = Column(Date)
    end_date = Column(Date)
    
    patient = relationship("Patient", back_populates="addresses")

class PhoneNumber(Base):
    __tablename__ = "phone_numbers"
    
    id = Column(Integer, primary_key=True)
    patient_id = Column(Integer, ForeignKey("patients.id"))
    number = Column(String(20))
    type = Column(String(20))  # mobile, home, work
    is_primary = Column(Boolean, default=False)
    country_code = Column(String(5))
    
    patient = relationship("Patient", back_populates="phone_numbers")