-- =====================================================
-- STEP BY STEP FIX - Run each section separately
-- =====================================================

-- SECTION 1: CREATE USER (Run as SYSTEM)
-- Connect as SYSTEM user first, then run:

CREATE USER nmit_portal IDENTIFIED BY "808801@AbhiDB";
GRANT CONNECT, RESOURCE, CREATE SESSION TO nmit_portal;
GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO nmit_portal;
GRANT UNLIMITED TABLESPACE TO nmit_portal;

-- Verify user created
SELECT username, account_status FROM dba_users WHERE username = 'NMIT_PORTAL';

-- SECTION 2: CREATE TABLES (Connect as nmit_portal user)
-- Now connect as nmit_portal user with password: 808801@AbhiDB

-- Create sequences first
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

-- SECTION 3: INSERT DATA (Still as nmit_portal user)

-- Insert AIML Department
INSERT INTO departments (id, code, name, description, head_of_department, created_by) 
VALUES (department_seq.NEXTVAL, 'AIML', 'Artificial Intelligence and Machine Learning', 'Department of AI and ML', 'Dr. AIML Head', 'ADMIN');

-- Insert User for USN 1NT23AI004
INSERT INTO users (id, username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) 
VALUES (user_seq.NEXTVAL, '1nt23ai004', '1nt23ai004@nmit.edu.in', '$2a$10$C0BJByD3kVPO2CB9EUzB9.wGZ3sm4VvPLPv7DUKo2VsZvZBr2xLzH', 'Test', 'Student', '9876543004', 'STUDENT', 1, 'ADMIN');

-- Insert Student Record (USN: 1NT23AI004, DOB: 19/04/2004)
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

COMMIT;

-- SECTION 4: VERIFY DATA
SELECT 'DATABASE SETUP COMPLETED!' as STATUS FROM dual;

-- Check student data
SELECT 
    u.username as "Login_Username",
    s.usn as "USN",
    u.first_name || ' ' || u.last_name as "Full_Name",
    TO_CHAR(s.date_of_birth, 'DD/MM/YYYY') as "Date_of_Birth",
    d.name as "Department"
FROM users u
JOIN students s ON u.id = s.user_id
JOIN departments d ON s.department_id = d.id
WHERE s.usn = '1NT23AI004';

SELECT '✅ Ready to test login: USN=1NT23AI004, DOB=19/04/2004' as MESSAGE FROM dual;