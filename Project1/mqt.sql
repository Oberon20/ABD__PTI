SELECT
  d.doctor_id,
  d.name,
  d.qualification,
  d.department_id,
  dept.department_name
FROM hospital_management.ALL_DOCTORS d
INNER JOIN hospital_management.DEPARTMENT dept
ON d.department_id = dept.department_id;
