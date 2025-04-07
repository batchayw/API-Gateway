import requests
import unittest
import os

BASE_URL = os.getenv("API_BASE_URL", "http://localhost:8000")
VALID_NSS = "1234567890123"
INVALID_NSS = "0000000000000"

class TestMedicalAPI(unittest.TestCase):
    def test_health_endpoint(self):
        """Teste le endpoint /health"""
        response = requests.get(f"{BASE_URL}/health")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), {"status": "healthy"})

    def test_valid_patient_query(self):
        """Teste une requête valide avec un NSS existant"""
        response = requests.get(f"{BASE_URL}/api/patient/{VALID_NSS}")
        
        self.assertEqual(response.status_code, 200)
        data = response.json()
        
        # Vérifie la structure de base
        self.assertIn("personal_info", data)
        self.assertIn("medical_history", data)
        self.assertIn("academic_history", data)
        
        # Vérifie des champs spécifiques
        self.assertEqual(data["personal_info"]["nss"], VALID_NSS)
        self.assertIsInstance(data["medical_history"], list)
        self.assertIsInstance(data["academic_history"], list)

    def test_invalid_patient_query(self):
        """Teste une requête avec un NSS invalide"""
        response = requests.get(f"{BASE_URL}/api/patient/{INVALID_NSS}")
        
        self.assertEqual(response.status_code, 404)
        error_data = response.json()
        self.assertIn("detail", error_data)

    def test_metrics_endpoint(self):
        """Teste le endpoint /metrics"""
        response = requests.get(f"{BASE_URL}/metrics")
        self.assertEqual(response.status_code, 200)
        self.assertIn("text/plain", response.headers["Content-Type"])
        self.assertIn("process_cpu_seconds_total", response.text)

    @classmethod
    def setUpClass(cls):
        """Vérifie que l'API est accessible avant les tests"""
        try:
            response = requests.get(f"{BASE_URL}/health", timeout=5)
            if response.status_code != 200:
                raise ConnectionError(f"API non disponible (status: {response.status_code})")
        except Exception as e:
            raise ConnectionError(f"Impossible de se connecter à l'API: {str(e)}")

if __name__ == "__main__":
    unittest.main(verbosity=2)