-- ==============================================
-- DIAGNOSTIC & FIX SCRIPT FOR LOGIN ISSUES
-- Run as SYSTEM user in SQL Developer
-- ==============================================

-- STEP 1: Check if nmit_portal user exists
SELECT 'CHECKING USER STATUS...' as step FROM dual;
SELECT username, account_status, created FROM dba_users WHERE username = 'NMIT_PORTAL';

-- STEP 2: Create/Fix nmit_portal user
-- Drop and recreate to ensure clean state
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP USER nmit_portal CASCADE';
        DBMS_OUTPUT.PUT_LINE('✅ Dropped existing nmit_portal user');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ℹ️ No existing user to drop: ' || SQLERRM);
    END;
END;
/

-- Create fresh user
CREATE USER nmit_portal IDENTIFIED BY "808801@AbhiDB";
GRANT CONNECT, RESOURCE, CREATE SESSION TO nmit_portal;
GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO nmit_portal;
GRANT UNLIMITED TABLESPACE TO nmit_portal;

SELECT '✅ nmit_portal user created successfully' as status FROM dual;

-- STEP 3: Switch to nmit_portal schema and create tables
CONNECT nmit_portal/"808801@AbhiDB"@localhost:1521/FREE

-- Create sequences
CREATE SEQUENCE user_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE department_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE student_seq START WITH 1 INCREMENT BY 1;

SELECT '✅ Sequences created successfully' as status FROM dual;

-- Create departments table
CREATE TABLE departments (
    id NUMBER PRIMARY KEY,
    code VARCHAR2(10) NOT NULL UNIQUE,
    name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    head_of_department VARCHAR2(100),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(50) NOT NULL,
    updated_by VARCHAR2(50)
);

-- Create users table
CREATE TABLE users (
    id NUMBER PRIMARY KEY,
    username VARCHAR2(50) NOT NULL UNIQUE,
    email VARCHAR2(100) NOT NULL UNIQUE,
    password VARCHAR2(255) NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    phone_number VARCHAR2(20),
    role VARCHAR2(20) NOT NULL CHECK (role IN ('ADMIN', 'FACULTY', 'STUDENT', 'STAFF')),
    is_email_verified NUMBER(1) DEFAULT 0,
    email_verification_token VARCHAR2(255),
    password_reset_token VARCHAR2(255),
    last_login_date TIMESTAMP,
    account_locked NUMBER(1) DEFAULT 0,
    failed_login_attempts NUMBER DEFAULT 0,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(50) NOT NULL,
    updated_by VARCHAR2(50)
);

-- Create students table
CREATE TABLE students (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    department_id NUMBER NOT NULL,
    usn VARCHAR2(20) NOT NULL UNIQUE,
    admission_number VARCHAR2(20) NOT NULL UNIQUE,
    batch_year NUMBER NOT NULL,
    current_semester NUMBER,
    cgpa NUMBER(3,2) DEFAULT 0.0,
    date_of_birth DATE NOT NULL,
    gender VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    address VARCHAR2(500),
    parent_name VARCHAR2(100),
    parent_phone VARCHAR2(20),
    parent_email VARCHAR2(100),
    admission_date DATE,
    graduation_date DATE,
    status VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'GRADUATED', 'SUSPENDED')),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(50) NOT NULL,
    updated_by VARCHAR2(50),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

SELECT '✅ Tables created successfully' as status FROM dual;

-- STEP 4: Insert test data for USN 1NT23AI004
-- Insert AIML Department
INSERT INTO departments (id, code, name, description, head_of_department, created_by) 
VALUES (1, 'AIML', 'Artificial Intelligence and Machine Learning', 'Department of AI and ML', 'Dr. AIML Head', 'ADMIN');

-- Insert User (username must match USN for login)
INSERT INTO users (id, username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) 
VALUES (1, '1nt23ai004', '1nt23ai004@nmit.edu.in', '$2a$10$C0BJByD3kVPO2CB9EUzB9.wGZ3sm4VvPLPv7DUKo2VsZvZBr2xLzH', 'Test', 'Student', '9876543004', 'STUDENT', 1, 'ADMIN');

-- Insert Student Record (USN: 1NT23AI004, DOB: 19/04/2004)
INSERT INTO students (id, user_id, department_id, usn, admission_number, batch_year, current_semester, cgpa, date_of_birth, gender, address, parent_name, parent_phone, parent_email, admission_date, status, created_by) 
VALUES (1, 1, 1, '1NT23AI004', 'ADM2023004', 2023, 5, 8.50, DATE '2004-04-19', 'Male', 'Test Address', 'Test Parent', '9876543004', 'test@example.com', DATE '2023-08-01', 'ACTIVE', 'ADMIN');

COMMIT;

SELECT '✅ Test data inserted successfully' as status FROM dual;

-- STEP 5: VERIFY LOGIN DATA
SELECT 'LOGIN VERIFICATION DATA:' as info FROM dual;

-- Check if student exists with correct data
SELECT 
    u.username as "Login_Username",
    s.usn as "Display_USN",
    TO_CHAR(s.date_of_birth, 'DD/MM/YYYY') as "DOB_Display",
    TO_CHAR(s.date_of_birth, 'YYYY-MM-DD') as "DOB_Backend_Format",
    u.first_name || ' ' || u.last_name as "Full_Name",
    u.role as "Role"
FROM users u
JOIN students s ON u.id = s.user_id
WHERE s.usn = '1NT23AI004';

-- Test the exact login query that backend will use
SELECT 
    'BACKEND LOGIN TEST:' as test_type,
    u.id,
    u.username,
    u.password,
    u.first_name,
    u.last_name,
    s.usn,
    s.date_of_birth
FROM users u
JOIN students s ON u.id = s.user_id
WHERE UPPER(u.username) = UPPER('1nt23ai004')
  AND s.date_of_birth = DATE '2004-04-19';

SELECT '🎯 READY FOR LOGIN TEST!' as final_status FROM dual;
SELECT 'Use these credentials:' as instruction FROM dual;
SELECT '📱 Frontend URL: http://localhost:5175/' as frontend FROM dual;
SELECT '🔑 USN: 1NT23AI004' as usn FROM dual;
SELECT '📅 DOB: 19/04/2004' as dob FROM dual;

