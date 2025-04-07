#!/bin/bash

# Teste point
echo "Testing health endpoint:"
curl -X GET http://localhost/api/health
echo -e "\n"

# Teste le patient avec NSS valide
echo "Testing patient endpoint with valid NSS:"
curl -X GET http://localhost/api/patient/1234567890123
echo -e "\n"

# Teste le patient avec NSS invalide
echo "Testing patient endpoint with invalid NSS:"
curl -X GET http://localhost/api/patient/invalid
echo -e "\n"