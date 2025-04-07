CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    nss VARCHAR(13) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender VARCHAR(20),
    nationality VARCHAR(100),
    height FLOAT,
    weight FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE medical_records (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id),
    record_type VARCHAR(50) NOT NULL,
    description TEXT,
    date DATE NOT NULL,
    location VARCHAR(100),
    treatment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE academic_history (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id),
    degree VARCHAR(100) NOT NULL,
    institution VARCHAR(100) NOT NULL,
    start_year INTEGER NOT NULL,
    end_year INTEGER,
    country VARCHAR(100),
    city VARCHAR(100),
    average FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id),
    street VARCHAR(100),
    city VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    is_current BOOLEAN DEFAULT TRUE,
    start_date DATE,
    end_date DATE
);

CREATE TABLE phone_numbers (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id),
    number VARCHAR(20) NOT NULL,
    type VARCHAR(20),
    is_primary BOOLEAN DEFAULT FALSE,
    country_code VARCHAR(5)
);