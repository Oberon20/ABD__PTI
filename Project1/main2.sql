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
