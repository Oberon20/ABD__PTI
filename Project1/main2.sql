CREATE SCHEMA hospital_management;

CREATE TABLE hospital_management.DEPARTMENT (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE,
    department_location VARCHAR(100),
    facilities_available VARCHAR(255)
);

CREATE TABLE hospital_management.ALL_DOCTORS (
    doctor_id VARCHAR(10) PRIMARY KEY,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES hospital_management.DEPARTMENT(department_id)
);

CREATE TABLE hospital_management.DOC_REG (
    doctor_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    qualification VARCHAR(100),
    address VARCHAR(255),
    phone_number VARCHAR(15),
    salary DECIMAL(10, 2),
    date_of_joining DATE,
    FOREIGN KEY (doctor_id) REFERENCES hospital_management.ALL_DOCTORS(doctor_id)
);

CREATE TABLE hospital_management.DOC_ON_CALL (
    doctor_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    qualification VARCHAR(100),
    fees_per_call DECIMAL(10, 2),
    payment_due DECIMAL(10, 2),
    address VARCHAR(255),
    phone_number VARCHAR(15),
    FOREIGN KEY (doctor_id) REFERENCES hospital_management.ALL_DOCTORS(doctor_id)
);

CREATE TABLE hospital_management.PAT_ENTRY (
    patient_number VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender ENUM('M', 'F'),
    address VARCHAR(255),
    city VARCHAR(100),
    phone_number VARCHAR(15),
    entry_date DATE,
    doctor_id VARCHAR(10),
    diagnosis VARCHAR(255),
    department_name VARCHAR(100),
    FOREIGN KEY (doctor_id) REFERENCES hospital_management.ALL_DOCTORS(doctor_id)
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
