CREATE VIEW hospital_management.PATIENTS_DOCTORS AS
SELECT
  p.patient_id,
  p.name AS patient_name,
  d.doctor_number,
  d.name AS doctor_name,
  dept.department_name
FROM hospital_management.PAT_ENTRY p
INNER JOIN hospital_management.ALL_DOCTORS d
ON p.referred_doctor = d.doctor_id
INNER JOIN hospital_management.DEPARTMENT dept
ON d.department_id = dept.department_id;
