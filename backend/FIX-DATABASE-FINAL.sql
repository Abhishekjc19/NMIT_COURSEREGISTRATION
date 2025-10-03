-- Fix database setup for Oracle FREE (multitenant)
-- Connect as SYSTEM and run this script

-- Step 1: Enable oracle script mode to bypass multitenant restrictions
ALTER SESSION SET "_ORACLE_SCRIPT"=true;

-- Step 2: Drop user if exists (ignore errors)
DROP USER nmit_portal CASCADE;

-- Step 3: Create nmit_portal user
CREATE USER nmit_portal IDENTIFIED BY "808801@AbhiDB";

-- Step 4: Grant necessary privileges
GRANT CONNECT, RESOURCE, CREATE SESSION TO nmit_portal;
GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO nmit_portal;
GRANT UNLIMITED TABLESPACE TO nmit_portal;

-- Step 5: Switch to nmit_portal schema
ALTER SESSION SET CURRENT_SCHEMA = nmit_portal;

-- Step 6: Create tables
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

-- Step 7: Insert sample data
INSERT INTO departments (id, code, name, description, head_of_department, created_by) 
VALUES (1, 'AIML', 'Artificial Intelligence and Machine Learning', 'Department of AI and ML', 'Dr. AIML Head', 'ADMIN');

INSERT INTO users (id, username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) 
VALUES (1, '1nt23ai004', '1nt23ai004@nmit.edu.in', '$2a$10$C0BJByD3kVPO2CB9EUzB9.wGZ3sm4VvPLPv7DUKo2VsZvZBr2xLzH', 'Student', 'AIML', '9876543004', 'STUDENT', 1, 'ADMIN');

INSERT INTO students (id, user_id, department_id, usn, admission_number, batch_year, current_semester, cgpa, date_of_birth, gender, address, parent_name, parent_phone, parent_email, admission_date, status, created_by) 
VALUES (1, 1, 1, '1NT23AI004', 'ADM2023004', 2023, 5, 8.50, DATE '2004-04-19', 'Male', 'Bangalore', 'Parent Name', '9876543004', 'parent@email.com', DATE '2023-08-01', 'ACTIVE', 'ADMIN');

COMMIT;

-- Step 8: Verify setup
SELECT 'Setup Complete!' as status FROM dual;
SELECT username as "Login_Username", TO_CHAR(date_of_birth, 'DD/MM/YYYY') as "DOB_Format" FROM users u JOIN students s ON u.id = s.user_id WHERE s.usn = '1NT23AI004';