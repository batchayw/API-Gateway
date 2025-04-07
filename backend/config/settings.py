import os
from pydantic import BaseSettings, PostgresDsn, validator # type: ignore
from typing import Optional

class Settings(BaseSettings):
    # Configuration de la base de données
    DATABASE_URL: PostgresDsn = "postgresql://user:password@localhost:5432/medical_db"
    DB_POOL_SIZE: int = 20
    DB_MAX_OVERFLOW: int = 5
    
    # Configuration de sécurité
    ENCRYPTION_KEY: str = "votre-clé-secrète-par-défaut"
    HASH_SALT: str = "salt-de-sécurité-par-défaut"
    
    # Configuration de l'application
    APP_NAME: str = "Medical Records API"
    DEBUG: bool = False
    LOG_LEVEL: str = "INFO"
    
    # Configuration CORS
    CORS_ORIGINS: list = ["*"]
    CORS_METHODS: list = ["*"]
    CORS_HEADERS: list = ["*"]
    
    class Config:
        env_file = ".env"
        case_sensitive = True
    
    @validator("DATABASE_URL")
    def validate_db_url(cls, v):
        if not v:
            raise ValueError("URL de base de données non configurée")
        return v

# Instance singleton des paramètres
settings = Settings()

def get_settings() -> Settings:
    """Retourne les paramètres de configuration"""
    return settings