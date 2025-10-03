-- NMIT AIML Batch 2027 Students Data Import
-- Replace the sample data below with your actual Excel data

-- First, let's add the AIML department if it doesn't exist
-- For Oracle, use MERGE statement:
MERGE INTO departments d
USING (SELECT 'AIML' as code, 'Artificial Intelligence and Machine Learning' as name, 
              'Department of AI and ML' as description, 'Dr. AIML Head' as head_of_department, 
              'ADMIN' as created_by FROM DUAL) src
ON (d.code = src.code)
WHEN NOT MATCHED THEN 
    INSERT (code, name, description, head_of_department, created_by)
    VALUES (src.code, src.name, src.description, src.head_of_department, src.created_by);

-- Template for student data - Replace with your Excel data
-- FORMAT: USN, Student Name, Email, Phone, DOB, Gender, Address, Parent Name, Parent Phone, Parent Email

-- Example entries (replace these with your actual Excel data):
-- Student 1
INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) 
VALUES ('4nm27ai001', '4nm27ai001@nmit.edu.in', '$2a$10$default_password_hash', 'Student', 'Name1', '9876543001', 'STUDENT', 1, 'ADMIN');

INSERT INTO students (user_id, department_id, usn, admission_number, batch_year, current_semester, cgpa, date_of_birth, gender, address, parent_name, parent_phone, parent_email, admission_date, status, created_by) 
VALUES (
    (SELECT id FROM users WHERE username = '4nm27ai001'),
    (SELECT id FROM departments WHERE code = 'AIML'),
    '4NM27AI001',
    'ADM2027001',
    2027,
    1,
    0.0,
    DATE '2005-01-01',
    'Male',
    'Address 1',
    'Parent Name 1',
    '9876543001',
    'parent1@gmail.com',
    DATE '2027-08-01',
    'ACTIVE',
    'ADMIN'
);

-- Student 2
INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) 
VALUES ('4nm27ai002', '4nm27ai002@nmit.edu.in', '$2a$10$default_password_hash', 'Student', 'Name2', '9876543002', 'STUDENT', 1, 'ADMIN');

INSERT INTO students (user_id, department_id, usn, admission_number, batch_year, current_semester, cgpa, date_of_birth, gender, address, parent_name, parent_phone, parent_email, admission_date, status, created_by) 
VALUES (
    (SELECT id FROM users WHERE username = '4nm27ai002'),
    (SELECT id FROM departments WHERE code = 'AIML'),
    '4NM27AI002',
    'ADM2027002',
    2027,
    1,
    0.0,
    DATE '2005-02-01',
    'Female',
    'Address 2',
    'Parent Name 2',
    '9876543002',
    'parent2@gmail.com',
    DATE '2027-08-01',
    'ACTIVE',
    'ADMIN'
);

-- Add more students following the same pattern...
-- Copy this template for each student in your Excel file

-- After adding all students, verify the data:
SELECT 
    u.username as USN,
    u.first_name,
    u.last_name,
    d.name as department,
    s.batch_year,
    s.current_semester
FROM users u
JOIN students s ON u.id = s.user_id
JOIN departments d ON s.department_id = d.id
WHERE d.code = 'AIML'
ORDER BY u.username;

COMMIT;