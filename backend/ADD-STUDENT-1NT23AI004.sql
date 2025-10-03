-- =================================================
-- ADD STUDENT: USN 1NT23AI004, DOB 19/04/2004
-- Run this in VS Code Oracle SQL Developer Extension or SQL Developer
-- =================================================

-- Step 1: Switch to nmit_portal schema (or create if not exists)
-- If nmit_portal user doesn't exist, create it first:
-- CREATE USER nmit_portal IDENTIFIED BY "808801@AbhiDB";
-- GRANT CONNECT, RESOURCE, CREATE SESSION TO nmit_portal;
-- GRANT UNLIMITED TABLESPACE TO nmit_portal;

-- Connect as nmit_portal user or use: ALTER SESSION SET CURRENT_SCHEMA = nmit_portal;

-- Step 2: Create AIML Department (if not exists)
INSERT INTO departments (id, code, name, description, head_of_department, created_by) 
SELECT 1, 'AIML', 'Artificial Intelligence and Machine Learning', 'Department of AI and ML', 'Dr. AIML Head', 'ADMIN'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM departments WHERE code = 'AIML');

-- Step 3: Add User for USN 1NT23AI004
INSERT INTO users (id, username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) 
SELECT 1, '1nt23ai004', '1nt23ai004@nmit.edu.in', '$2a$10$C0BJByD3kVPO2CB9EUzB9.wGZ3sm4VvPLPv7DUKo2VsZvZBr2xLzH', 'Test', 'Student', '9876543004', 'STUDENT', 1, 'ADMIN'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = '1nt23ai004');

-- Step 4: Add Student Record for USN 1NT23AI004, DOB 19/04/2004
INSERT INTO students (id, user_id, department_id, usn, admission_number, batch_year, current_semester, cgpa, date_of_birth, gender, address, parent_name, parent_phone, parent_email, admission_date, status, created_by) 
SELECT 
    1,
    (SELECT id FROM users WHERE username = '1nt23ai004'),
    (SELECT id FROM departments WHERE code = 'AIML'),
    '1NT23AI004',
    'ADM2023004',
    2023,
    5,
    8.50,
    DATE '2004-04-19',  -- DOB: 19/04/2004
    'Male',
    'Test Address, Bangalore',
    'Test Parent Name',
    '9876543004',
    'testparent@example.com',
    DATE '2023-08-01',
    'ACTIVE',
    'ADMIN'
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM students WHERE usn = '1NT23AI004');

-- Step 5: Verify the student was added successfully
SELECT 'STUDENT ADDED SUCCESSFULLY!' as STATUS FROM dual;

-- Verify student details
SELECT 
    u.username as "Login_Username",
    s.usn as "USN",
    u.first_name || ' ' || u.last_name as "Full_Name",
    TO_CHAR(s.date_of_birth, 'DD/MM/YYYY') as "Date_of_Birth",
    d.name as "Department",
    s.batch_year as "Batch_Year",
    s.current_semester as "Current_Semester",
    s.status as "Status"
FROM users u
JOIN students s ON u.id = s.user_id
JOIN departments d ON s.department_id = d.id
WHERE s.usn = '1NT23AI004';

-- Test login verification query
SELECT 
    'LOGIN TEST DATA:' as info,
    u.username as "username_for_login",
    s.usn as "display_usn", 
    TO_CHAR(s.date_of_birth, 'DD/MM/YYYY') as "dob_for_login",
    'student123' as "default_password"
FROM users u
JOIN students s ON u.id = s.user_id
WHERE s.usn = '1NT23AI004';

COMMIT;

SELECT '✅ READY TO TEST LOGIN WITH: USN=1NT23AI004, DOB=19/04/2004' as FINAL_MESSAGE FROM dual;