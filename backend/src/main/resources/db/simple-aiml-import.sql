-- AIML Students Import - Simple Version
-- Run this in SQL Developer as SYSTEM user first, then as nmit_portal user

-- Step 1: Create AIML Department (run as SYSTEM or nmit_portal)
INSERT INTO departments (code, name, description, head_of_department, created_by) 
VALUES ('AIML', 'Artificial Intelligence and Machine Learning', 'Department of AI and ML', 'Dr. AIML Head', 'ADMIN');

-- Step 2: Add sample AIML students
-- Replace these with your actual Excel data

-- Student 1 - Real test data: USN 1NT23AI004, DOB 19/04/2004
INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) 
VALUES ('1nt23ai004', '1nt23ai004@nmit.edu.in', '$2a$10$C0BJByD3kVPO2CB9EUzB9.wGZ3sm4VvPLPv7DUKo2VsZvZBr2xLzH', 'Test', 'Student', '9876543004', 'STUDENT', 1, 'ADMIN');

INSERT INTO students (user_id, department_id, usn, admission_number, batch_year, current_semester, cgpa, date_of_birth, gender, address, parent_name, parent_phone, parent_email, admission_date, status, created_by) 
VALUES (
    (SELECT id FROM users WHERE username = '1nt23ai004'),
    (SELECT id FROM departments WHERE code = 'AIML'),
    '1NT23AI004',
    'ADM2023004',
    2023,
    5,
    0.0,
    DATE '2004-04-19',
    'Male',
    'Test Address',
    'Test Parent',
    '9876543004',
    'testparent@example.com',
    DATE '2023-08-01',
    'ACTIVE',
    'ADMIN'
);

-- Student 2 - Replace with actual data from Excel
INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) 
VALUES ('4nm27ai002', '4nm27ai002@nmit.edu.in', '$2a$10$C0BJByD3kVPO2CB9EUzB9.wGZ3sm4VvPLPv7DUKo2VsZvZBr2xLzH', 'Sample', 'Student2', '9876543002', 'STUDENT', 1, 'ADMIN');

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
    'Sample Address 2',
    'Parent Name 2',
    '9876543002',
    'parent2@example.com',
    DATE '2027-08-01',
    'ACTIVE',
    'ADMIN'
);

-- Add more students here following the same pattern
-- Copy the INSERT statements above for each student in your Excel file

-- Verify the data was inserted
SELECT 
    u.username as USN,
    u.first_name || ' ' || u.last_name as Name,
    d.name as Department,
    s.batch_year,
    s.current_semester,
    s.date_of_birth
FROM users u
JOIN students s ON u.id = s.user_id
JOIN departments d ON s.department_id = d.id
WHERE d.code = 'AIML'
ORDER BY u.username;

-- Test query to verify your specific student
SELECT 
    u.username,
    s.usn,
    s.date_of_birth,
    u.first_name || ' ' || u.last_name as full_name
FROM users u
JOIN students s ON u.id = s.user_id
WHERE UPPER(u.username) = '1NT23AI004';

COMMIT;