from cryptography.fernet import Fernet
import base64
import os
from typing import Union

class DataEncryptor:
    def __init__(self):
        # Clé de chiffrement générée ou récupérée depuis les variables d'environnement
        self.key = os.getenv('ENCRYPTION_KEY', self._generate_key())
        self.cipher_suite = Fernet(self.key)

    def _generate_key(self) -> str:
        """Génère une clé de chiffrement sécurisée"""
        return Fernet.generate_key().decode()

    def encrypt_data(self, data: Union[str, bytes]) -> str:
        """Chiffre les données sensibles"""
        if isinstance(data, str):
            data = data.encode()
        encrypted_data = self.cipher_suite.encrypt(data)
        return base64.b64encode(encrypted_data).decode()

    def decrypt_data(self, encrypted_data: str) -> str:
        """Déchiffre les données"""
        encrypted_data = base64.b64decode(encrypted_data.encode())
        return self.cipher_suite.decrypt(encrypted_data).decode()

    @staticmethod
    def hash_sensitive_data(data: str, salt: str = None) -> str:
        """Hachage des données ultra-sensibles (comme les NSS)"""
        import hashlib
        if not salt:
            salt = os.urandom(16).hex()
        return hashlib.sha512((data + salt).encode()).hexdigest()

# Exemple d'utilisation
if __name__ == "__main__":
    encryptor = DataEncryptor()
    test_data = "1234567890123"  # NSS
    encrypted = encryptor.encrypt_data(test_data)
    print(f"Encrypted: {encrypted}")
    print(f"Decrypted: {encryptor.decrypt_data(encrypted)}")
    print(f"Hashed: {encryptor.hash_sensitive_data(test_data)}")