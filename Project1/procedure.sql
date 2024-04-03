CREATE SCHEMA hospital_management;

-- Function to generate doctor ID (assuming a fixed prefix and sequential numbering)
CREATE FUNCTION hospital_management.GET_DOC_ID()
RETURNS VARCHAR(10)
BEGIN
  DECLARE new_id VARCHAR(10);
  DECLARE counter INT;

  SELECT CONCAT('DR', LPAD(MAX(SUBSTRING(doctor_number, 3)), 4, '0')) + 1
  INTO new_id
  FROM hospital_management.ALL_DOCTORS;

  IF new_id IS NULL THEN
    SET new_id = 'DR0001';
  END IF;

  RETURN new_id;
END;

-- Procedure to add a new regular doctor
CREATE PROCEDURE hospital_management.ADD_REG_DOC(
  IN department_id INT,
  IN name VARCHAR(255),
  IN qualification VARCHAR(255),
  IN address VARCHAR(255),
  IN phone_number VARCHAR(255),
  IN salary DECIMAL(10,2),
  IN date_of_joining DATE
)
BEGIN
  DECLARE doctor_number VARCHAR(10);
  DECLARE errorMessage VARCHAR(255);

  -- Input validation
  IF department_id <= 0 THEN
    SET errorMessage = 'Invalid department ID. Please provide a positive value.';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errorMessage;
  END IF;

  -- Generate doctor number
  SET doctor_number = hospital_management.GET_DOC_ID();

  -- Insert into ALL_DOCTORS
  INSERT INTO hospital_management.ALL_DOCTORS (doctor_id, department_id)
  VALUES (doctor_number, department_id);

  -- Insert into DOC_REG
  INSERT INTO hospital_management.DOC_REG (doctor_number, name, qualification, address, phone_number, salary, date_of_joining)
  VALUES (doctor_number, name, qualification, address, phone_number, salary, date_of_joining);
END;

-- Rest of the table definitions from previous script...
