-- =================================================
-- COMPLETE NMIT PORTAL DATABASE SETUP
-- Run this ENTIRE script in SQL Developer as SYSTEM user
-- =================================================

-- Step 1: Create nmit_portal user (if not exists)
BEGIN
    -- Drop user if exists (ignore errors)
    BEGIN
        EXECUTE IMMEDIATE 'DROP USER nmit_portal CASCADE';
        DBMS_OUTPUT.PUT_LINE('User nmit_portal dropped successfully');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('User nmit_portal does not exist or error: ' || SQLERRM);
    END;
    
    -- Create user
    EXECUTE IMMEDIATE 'CREATE USER nmit_portal IDENTIFIED BY "808801@AbhiDB"';
    DBMS_OUTPUT.PUT_LINE('User nmit_portal created successfully');
    
    -- Grant privileges
    EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE, CREATE SESSION TO nmit_portal';
    EXECUTE IMMEDIATE 'GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO nmit_portal';
    EXECUTE IMMEDIATE 'GRANT UNLIMITED TABLESPACE TO nmit_portal';
    DBMS_OUTPUT.PUT_LINE('Privileges granted to nmit_portal');
END;
/

-- Step 2: Create all tables as nmit_portal user
-- Switch to nmit_portal user context
ALTER SESSION SET CURRENT_SCHEMA = nmit_portal;

-- Create sequences
CREATE SEQUENCE user_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE department_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE student_seq START WITH 1 INCREMENT BY 1;

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

-- Step 3: Insert AIML Department
INSERT INTO departments (id, code, name, description, head_of_department, created_by) 
VALUES (department_seq.NEXTVAL, 'AIML', 'Artificial Intelligence and Machine Learning', 'Department of AI and ML', 'Dr. AIML Head', 'ADMIN');

-- Step 4: Insert test student (USN: 1NT23AI004, DOB: 19/04/2004)
-- Insert user record
INSERT INTO users (id, username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) 
VALUES (user_seq.NEXTVAL, '1nt23ai004', '1nt23ai004@nmit.edu.in', '$2a$10$C0BJByD3kVPO2CB9EUzB9.wGZ3sm4VvPLPv7DUKo2VsZvZBr2xLzH', 'Test', 'Student', '9876543004', 'STUDENT', 1, 'ADMIN');

-- Insert student record
INSERT INTO students (id, user_id, department_id, usn, admission_number, batch_year, current_semester, cgpa, date_of_birth, gender, address, parent_name, parent_phone, parent_email, admission_date, status, created_by) 
VALUES (
    student_seq.NEXTVAL,
    (SELECT id FROM users WHERE username = '1nt23ai004'),
    (SELECT id FROM departments WHERE code = 'AIML'),
    '1NT23AI004',
    'ADM2023004',
    2023,
    5,
    8.50,
    DATE '2004-04-19',
    'Male',
    'Test Address, Bangalore',
    'Test Parent Name',
    '9876543004',
    'testparent@example.com',
    DATE '2023-08-01',
    'ACTIVE',
    'ADMIN'
);

-- Step 5: Verify data inserted successfully
SELECT 'DATA INSERTION COMPLETED SUCCESSFULLY!' as STATUS FROM dual;

-- Verify department created
SELECT d.code, d.name, d.head_of_department 
FROM departments d 
WHERE d.code = 'AIML';

-- Verify student created
SELECT 
    u.username as "USERNAME",
    s.usn as "USN",
    u.first_name || ' ' || u.last_name as "FULL_NAME",
    TO_CHAR(s.date_of_birth, 'DD/MM/YYYY') as "DATE_OF_BIRTH",
    d.name as "DEPARTMENT",
    s.batch_year as "BATCH",
    s.current_semester as "SEMESTER",
    s.status as "STATUS"
FROM users u
JOIN students s ON u.id = s.user_id
JOIN departments d ON s.department_id = d.id
WHERE UPPER(u.username) = '1NT23AI004';

-- Test query for login verification
SELECT 
    u.username,
    s.usn,
    TO_CHAR(s.date_of_birth, 'YYYY-MM-DD') as formatted_dob,
    u.password
FROM users u
JOIN students s ON u.id = s.user_id
WHERE UPPER(u.username) = '1NT23AI004'
  AND s.date_of_birth = DATE '2004-04-19';

COMMIT;

SELECT 'READY FOR BACKEND CONNECTION TEST!' as FINAL_STATUS FROM dual;
CREATE USER nmit_portal IDENTIFIED BY "808801@AbhiDB";
GRANT CONNECT, RESOURCE, CREATE SESSION TO nmit_portal;
GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO nmit_portal;
GRANT UNLIMITED TABLESPACE TO nmit_portal;