CREATE SCHEMA hospital_management;

CREATE TABLE hospital_management.DEPARTMENT (
  department_id INT PRIMARY KEY AUTO_INCREMENT,
  department_name VARCHAR(255) UNIQUE,
  department_location VARCHAR(255),
  facilities VARCHAR(255)
);

CREATE TABLE hospital_management.ALL_DOCTORS (
  doctor_id VARCHAR(10) PRIMARY KEY, -- Change to appropriate length for your doctor ID format
  department_id INT,
  -- Add additional doctor information columns here (e.g., name, qualification)
  FOREIGN KEY (department_id) REFERENCES hospital_management.DEPARTMENT(department_id)
);

CREATE TABLE hospital_management.DOC_REG (
  doctor_number VARCHAR(10) PRIMARY KEY, -- Change to appropriate length for your doctor ID format
  name VARCHAR(255),
  qualification VARCHAR(255),
  address VARCHAR(255),
  phone_number VARCHAR(255),
  salary DECIMAL(10,2),
  date_of_joining DATE,
  -- Add additional doctor details specific to regular doctors here
  FOREIGN KEY (doctor_number) REFERENCES hospital_management.ALL_DOCTORS(doctor_id) -- Assuming doctor_number is the same as doctor_id for regular doctors
  CHECK (doctor_number LIKE 'DR%') -- Enforce "DR" prefix for regular doctors
);

CREATE TABLE hospital_management.DOC_ON_CALL (
  doctor_id VARCHAR(10) PRIMARY KEY, -- Change to appropriate length for your doctor ID format
  fees_per_call DECIMAL(10,2),
  payment_due DECIMAL(10,2),
  name VARCHAR(255),
  qualification VARCHAR(255),
  address VARCHAR(255),
  phone_number VARCHAR(255),
  -- Add additional doctor details specific to call on doctors here
  FOREIGN KEY (doctor_id) REFERENCES hospital_management.ALL_DOCTORS(doctor_id) -- References doctor_id in ALL_DOCTORS
  CHECK (doctor_id LIKE 'DC%') -- Enforce "DC" prefix for call on doctors
);

CREATE TABLE hospital_management.PAT_ENTRY (
  patient_id VARCHAR(10) PRIMARY KEY, -- Change to appropriate length for your patient ID format
  name VARCHAR(255),
  age INT,
  gender CHAR(1) CHECK (gender IN ('M', 'F')), -- Enforce gender to be 'M' or 'F'
  address VARCHAR(255),
  city VARCHAR(255),
  phone_number VARCHAR(255),
  entry_date DATE,
  referred_doctor VARCHAR(255), -- Doctor name (can be changed to doctor_id for efficiency)
  department_name VARCHAR(255),
  diagnosis VARCHAR(255),
  FOREIGN KEY (referred_doctor, department_name) REFERENCES hospital_management.ALL_DOCTORS(doctor_id, department_name) -- Ensure doctor and department exist
  CHECK (patient_id LIKE 'PT%') -- Enforce "PT" prefix for patient ID
);

CREATE TABLE hospital_management.PAT_CHKUP (
  patient_id VARCHAR(10) PRIMARY KEY,
  doctor_number VARCHAR(10),
  checkup_date DATE,
  diagnosis VARCHAR(255),
  treatment VARCHAR(255),
  status VARCHAR(255), -- Admitted, Operation, Regular
  FOREIGN KEY (patient_id) REFERENCES hospital_management.PAT_ENTRY(patient_id) UNIQUE, -- Patient ID must be unique and exist in PAT_ENTRY
  FOREIGN KEY (doctor_number) REFERENCES hospital_management.ALL_DOCTORS(doctor_id), -- Ensure doctor exists
  INDEX idx_patient_doctor (patient_id, doctor_number) -- Create index for faster lookups
);

CREATE TABLE hospital_management.PAT_ADMIT (
  patient_id VARCHAR(10) PRIMARY KEY,
  advance_payment DECIMAL(10,2),
  payment_mode VARCHAR(255),
  room_number INT,
  department_id INT,
  admission_date DATE,
  initial_condition VARCHAR(255),
  treatment VARCHAR(255),
  attendant_name VARCHAR(255),
  -- Add additional admission details here
  FOREIGN KEY (patient_id) REFERENCES hospital_management.PAT_ENTRY(patient_id), -- Ensure patient exists
  FOREIGN KEY (department_id) REFERENCES hospital_management.DEPARTMENT(department_id), -- Ensure department exists
  FOREIGN KEY (doctor_number) REFERENCES hospital_management.ALL_DOCTORS(doctor_id), -- Ensure doctor exists (optional, can be linked through PAT_CHKUP)
  CHECK (room_number > 0) -- Enforce positive room number (optional)
);

CREATE TABLE hospital_management.PAT_DIS (
  patient_id VARCHAR(10) PRIMARY KEY,
  treatment VARCHAR(255),
  treatment_advice VARCHAR(255),
  payment_made DECIMAL(10,2),
  payment_mode VARCHAR(255),
  discharge_date DATE,
  -- Add additional discharge details here
  FOREIGN KEY (patient_id) REFERENCES hospital_management.PAT_ENTRY(patient_id) -- Ensure patient exists
);

CREATE TABLE hospital_management.PAT_REG (
  patient_id VARCHAR(10) PRIMARY KEY,
  visit_date DATE,
  diagnosis VARCHAR(255),
  treatment VARCHAR(255),
  medicine_recommended VARCHAR(255),
  treatment_status VARCHAR(255),
  -- Add additional details for regular patient visits
  FOREIGN KEY (patient_id) REFERENCES hospital_management.PAT_ENTRY(patient_id) -- Ensure patient exists
);

CREATE TABLE hospital_management.PAT_OPR (
  patient_id VARCHAR(10) PRIMARY KEY,
  admission_date DATE,
  operation_date DATE,
  operating_doctor_number VARCHAR(10),
  operation_theater_number INT,
  operation_type VARCHAR(255),
  pre_op_condition VARCHAR(255),
  post_op_condition VARCHAR(255),
  treatment_advice VARCHAR(255),
  -- Add additional operation details here
  FOREIGN KEY (patient_id) REFERENCES hospital_management.PAT_ENTRY(patient_id), -- Ensure patient exists
  FOREIGN KEY (operating_doctor_number) REFERENCES hospital_management.ALL_DOCTORS(doctor_id), -- Ensure doctor exists
  CHECK (operation_theater_number > 0) -- Enforce positive operation theater number (optional)
);

CREATE TABLE hospital_management.ROOM_DETAILS (
  room_number INT PRIMARY KEY,
  room_type CHAR(1) CHECK (room_type IN ('G', 'P')), -- Enforce room type to be 'G' or 'P'
  status CHAR(1) CHECK (status IN ('Y', 'N')), -- Enforce status to be 'Y' or 'N'
  patient_id VARCHAR(10), -- Can be null if not occupied
  patient_name VARCHAR(255), -- Can be null if not occupied
  charges_per_day DECIMAL(10,2),
  FOREIGN KEY (patient_id) REFERENCES hospital_management.PAT_ENTRY(patient_id) -- Optional foreign key if room is occupied
);
