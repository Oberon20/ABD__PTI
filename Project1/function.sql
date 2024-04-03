CREATE SCHEMA hospital_management;

-- Function to generate doctor ID based on type
CREATE FUNCTION hospital_management.GET_DOC_ID(
  IN doc_type INT
)
RETURNS VARCHAR(10)
BEGIN
  DECLARE new_id VARCHAR(10);
  DECLARE prefix VARCHAR(2);

  IF doc_type = 1 THEN
    SET prefix = 'DR';
  ELSEIF doc_type = 2 THEN
    SET prefix = 'DC';
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid doctor type. Please provide 1 for regular doctor or 2 for call-on doctor.';
  END IF;

  SELECT CONCAT(prefix, LPAD(MAX(SUBSTRING(doctor_id, 3)), 4, '0')) + 1
  INTO new_id
  FROM hospital_management.ALL_DOCTORS
  WHERE doctor_id LIKE CONCAT(prefix, '%');

  IF new_id IS NULL THEN
    SET new_id = CONCAT(prefix, '0001');
  END IF;

  RETURN new_id;
END;

-- Procedure to add a new regular doctor (previous definition)
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

  -- ... (rest of ADD_REG_DOC procedure)
END;

-- Rest of the table definitions from previous script...
