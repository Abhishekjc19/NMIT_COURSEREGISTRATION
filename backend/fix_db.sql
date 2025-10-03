
connect system/"808801@Abhi"@localhost:1521/FREE

-- Create user
CREATE USER nmit_portal IDENTIFIED BY "808801@AbhiDB";
GRANT CONNECT, RESOURCE, CREATE SESSION TO nmit_portal;
GRANT UNLIMITED TABLESPACE TO nmit_portal;

-- Switch schema
ALTER SESSION SET CURRENT_SCHEMA = nmit_portal;

-- Create tables
CREATE TABLE departments (
    id NUMBER PRIMARY KEY,
    code VARCHAR2(10) UNIQUE,
    name VARCHAR2(100),
    created_by VARCHAR2(50)
);

CREATE TABLE users (
    id NUMBER PRIMARY KEY,
    username VARCHAR2(50) UNIQUE,
    email VARCHAR2(100),
    password VARCHAR2(255),
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    role VARCHAR2(20),
    created_by VARCHAR2(50)
);

CREATE TABLE students (
    id NUMBER PRIMARY KEY,
    user_id NUMBER,
    department_id NUMBER,
    usn VARCHAR2(20) UNIQUE,
    date_of_birth DATE,
    status VARCHAR2(20),
    created_by VARCHAR2(50)
);

-- Insert data
INSERT INTO departments VALUES (1, 'AIML', 'AI Department', 'ADMIN');
INSERT INTO users VALUES (1, '1nt23ai004', '1nt23ai004@nmit.edu.in', '$2a$10$C0BJByD3kVPO2CB9EUzB9.wGZ3sm4VvPLPv7DUKo2VsZvZBr2xLzH', 'Student', 'AIML', 'STUDENT', 'ADMIN');
INSERT INTO students VALUES (1, 1, 1, '1NT23AI004', DATE '2004-04-19', 'ACTIVE', 'ADMIN');

COMMIT;

SELECT 'DATABASE FIXED!' FROM dual;
exit

