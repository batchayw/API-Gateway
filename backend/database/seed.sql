INSERT INTO patients (nss, first_name, last_name, birth_date, gender, nationality, height, weight)
VALUES 
('1234567890123', 'Jean', 'Dupont', '1980-05-15', 'Male', 'French', 175.5, 70.2),
('9876543210987', 'Marie', 'Martin', '1990-08-22', 'Female', 'Belgian', 165.0, 58.7);

INSERT INTO medical_records (patient_id, record_type, description, date, location, treatment)
VALUES 
(1, 'Allergy', 'Peanut allergy', '2020-01-10', 'Paris Hospital', 'Antihistamines'),
(1, 'Diabetes', 'Type 2 diabetes', '2021-03-15', 'Lyon Clinic', 'Metformin'),
(2, 'Eye', 'Myopia correction', '2019-11-05', 'Brussels Eye Center', 'Glasses -2.5');

INSERT INTO academic_history (patient_id, degree, institution, start_year, end_year, country, city, average)
VALUES 
(1, 'BAC', 'Lycée Descartes', 1998, 1999, 'France', 'Tours', 14.5),
(1, 'Master', 'Université Paris-Saclay', 2004, 2006, 'France', 'Paris', 15.2),
(2, 'Licence', 'Université Libre de Bruxelles', 2010, 2013, 'Belgium', 'Brussels', 13.8);

INSERT INTO addresses (patient_id, street, city, postal_code, country, is_current, start_date, end_date)
VALUES
(1, '123 Rue de Paris', 'Paris', '75001', 'France', true, '2015-01-01', null),
(2, '46 Avenue des Champs', 'Lyon', '69005', 'France', false, '2014-01-01', '2019-12-31')
(1, '456 Avenue des Champs', 'Lyon', '69002', 'France', false, '2010-01-01', '2014-12-31');

INSERT INTO phone_numbers (patient_id, number, type, is_primary, country_code)
VALUES
(1, '0612345678', 'mobile', true, '+33'),
(2, '0712348678', 'mobile', true, '+33'),
(1, '0142057896', 'home', false, '+33');