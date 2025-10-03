-- NMIT Portal Database Schema for Oracle
-- Run this script as the NMIT_PORTAL user

-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE placement_records CASCADE CONSTRAINTS;
DROP TABLE results CASCADE CONSTRAINTS;
DROP TABLE admission_applications CASCADE CONSTRAINTS;
DROP TABLE courses CASCADE CONSTRAINTS;
DROP TABLE students CASCADE CONSTRAINTS;
DROP TABLE faculty CASCADE CONSTRAINTS;
DROP TABLE users CASCADE CONSTRAINTS;
DROP TABLE departments CASCADE CONSTRAINTS;

-- Drop sequences if they exist
DROP SEQUENCE dept_seq;
DROP SEQUENCE user_seq;
DROP SEQUENCE student_seq;
DROP SEQUENCE faculty_seq;
DROP SEQUENCE course_seq;
DROP SEQUENCE result_seq;
DROP SEQUENCE placement_seq;
DROP SEQUENCE admission_seq;

-- Create sequences
CREATE SEQUENCE dept_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE user_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE student_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE faculty_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE course_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE result_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE placement_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE admission_seq START WITH 1 INCREMENT BY 1;

-- Create Departments table
CREATE TABLE departments (
    id NUMBER(19) PRIMARY KEY,
    code VARCHAR2(10) NOT NULL UNIQUE,
    name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    head_of_department VARCHAR2(100),
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0,1)),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(50),
    updated_by VARCHAR2(50)
);

-- Create Users table
CREATE TABLE users (
    id NUMBER(19) PRIMARY KEY,
    username VARCHAR2(50) NOT NULL UNIQUE,
    email VARCHAR2(100) NOT NULL UNIQUE,
    password VARCHAR2(120) NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    phone_number VARCHAR2(15),
    role VARCHAR2(20) NOT NULL CHECK (role IN ('STUDENT', 'FACULTY', 'ADMIN', 'HOD', 'PRINCIPAL', 'PLACEMENT_OFFICER')),
    is_email_verified NUMBER(1) DEFAULT 0 CHECK (is_email_verified IN (0,1)),
    last_login TIMESTAMP,
    password_reset_token VARCHAR2(255),
    email_verification_token VARCHAR2(255),
    token_expiry TIMESTAMP,
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0,1)),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(50),
    updated_by VARCHAR2(50)
);

-- Create Students table
CREATE TABLE students (
    id NUMBER(19) PRIMARY KEY,
    user_id NUMBER(19) NOT NULL,
    department_id NUMBER(19) NOT NULL,
    usn VARCHAR2(20) NOT NULL UNIQUE,
    admission_number VARCHAR2(20) UNIQUE,
    batch_year NUMBER(4),
    current_semester NUMBER(2),
    cgpa NUMBER(4,2),
    date_of_birth DATE,
    gender VARCHAR2(10),
    address VARCHAR2(500),
    parent_name VARCHAR2(100),
    parent_phone VARCHAR2(15),
    parent_email VARCHAR2(100),
    admission_date DATE,
    graduation_date DATE,
    status VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'GRADUATED', 'SUSPENDED', 'DROPPED_OUT')),
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0,1)),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(50),
    updated_by VARCHAR2(50),
    CONSTRAINT fk_student_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_student_dept FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- Create Faculty table
CREATE TABLE faculty (
    id NUMBER(19) PRIMARY KEY,
    user_id NUMBER(19) NOT NULL,
    department_id NUMBER(19) NOT NULL,
    employee_id VARCHAR2(20) NOT NULL UNIQUE,
    designation VARCHAR2(50),
    qualification VARCHAR2(100),
    experience_years NUMBER(2),
    specialization VARCHAR2(100),
    date_of_joining DATE,
    office_room VARCHAR2(20),
    research_interests VARCHAR2(1000),
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0,1)),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(50),
    updated_by VARCHAR2(50),
    CONSTRAINT fk_faculty_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_faculty_dept FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- Create Courses table
CREATE TABLE courses (
    id NUMBER(19) PRIMARY KEY,
    department_id NUMBER(19) NOT NULL,
    faculty_id NUMBER(19),
    course_code VARCHAR2(20) NOT NULL UNIQUE,
    course_name VARCHAR2(200) NOT NULL,
    credits NUMBER(2),
    semester NUMBER(2),
    course_type VARCHAR2(20),
    description VARCHAR2(1000),
    syllabus VARCHAR2(2000),
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0,1)),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(50),
    updated_by VARCHAR2(50),
    CONSTRAINT fk_course_dept FOREIGN KEY (department_id) REFERENCES departments(id),
    CONSTRAINT fk_course_faculty FOREIGN KEY (faculty_id) REFERENCES faculty(id)
);

-- Create Results table
CREATE TABLE results (
    id NUMBER(19) PRIMARY KEY,
    student_id NUMBER(19) NOT NULL,
    course_id NUMBER(19) NOT NULL,
    internal_marks NUMBER(5,2),
    external_marks NUMBER(5,2),
    total_marks NUMBER(5,2),
    grade VARCHAR2(2),
    grade_points NUMBER(4,2),
    exam_type VARCHAR2(20),
    academic_year VARCHAR2(10),
    result_status VARCHAR2(10),
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0,1)),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(50),
    updated_by VARCHAR2(50),
    CONSTRAINT fk_result_student FOREIGN KEY (student_id) REFERENCES students(id),
    CONSTRAINT fk_result_course FOREIGN KEY (course_id) REFERENCES courses(id),
    CONSTRAINT uk_result_unique UNIQUE (student_id, course_id, exam_type, academic_year)
);

-- Create Placement Records table
CREATE TABLE placement_records (
    id NUMBER(19) PRIMARY KEY,
    student_id NUMBER(19) NOT NULL,
    company_name VARCHAR2(100) NOT NULL,
    job_title VARCHAR2(100),
    package_offered NUMBER(10,2),
    job_location VARCHAR2(100),
    placement_date DATE,
    offer_letter_date DATE,
    joining_date DATE,
    placement_type VARCHAR2(20),
    status VARCHAR2(20),
    company_category VARCHAR2(20),
    remarks VARCHAR2(500),
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0,1)),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(50),
    updated_by VARCHAR2(50),
    CONSTRAINT fk_placement_student FOREIGN KEY (student_id) REFERENCES students(id)
);

-- Create Admission Applications table
CREATE TABLE admission_applications (
    id NUMBER(19) PRIMARY KEY,
    department_id NUMBER(19),
    application_number VARCHAR2(20) NOT NULL UNIQUE,
    applicant_name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    phone_number VARCHAR2(15),
    date_of_birth DATE,
    gender VARCHAR2(10),
    address VARCHAR2(500),
    course_applied VARCHAR2(100),
    entrance_exam_score NUMBER(5,2),
    class_12_percentage NUMBER(5,2),
    class_10_percentage NUMBER(5,2),
    application_status VARCHAR2(20),
    application_date DATE,
    admission_date DATE,
    fee_paid NUMBER(10,2),
    parent_name VARCHAR2(100),
    parent_phone VARCHAR2(15),
    parent_occupation VARCHAR2(100),
    remarks VARCHAR2(500),
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0,1)),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR2(50),
    updated_by VARCHAR2(50),
    CONSTRAINT fk_admission_dept FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- Create indexes for better performance
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_students_usn ON students(usn);
CREATE INDEX idx_students_dept ON students(department_id);
CREATE INDEX idx_students_batch ON students(batch_year);
CREATE INDEX idx_faculty_emp_id ON faculty(employee_id);
CREATE INDEX idx_faculty_dept ON faculty(department_id);
CREATE INDEX idx_courses_code ON courses(course_code);
CREATE INDEX idx_courses_dept ON courses(department_id);
CREATE INDEX idx_results_student ON results(student_id);
CREATE INDEX idx_results_course ON results(course_id);
CREATE INDEX idx_results_year ON results(academic_year);
CREATE INDEX idx_placement_student ON placement_records(student_id);
CREATE INDEX idx_placement_company ON placement_records(company_name);
CREATE INDEX idx_admission_app_num ON admission_applications(application_number);
CREATE INDEX idx_admission_status ON admission_applications(application_status);

-- Create triggers for auto-incrementing primary keys
CREATE OR REPLACE TRIGGER trg_dept_id
    BEFORE INSERT ON departments
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := dept_seq.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_user_id
    BEFORE INSERT ON users
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := user_seq.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_student_id
    BEFORE INSERT ON students
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := student_seq.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_faculty_id
    BEFORE INSERT ON faculty
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := faculty_seq.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_course_id
    BEFORE INSERT ON courses
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := course_seq.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_result_id
    BEFORE INSERT ON results
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := result_seq.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_placement_id
    BEFORE INSERT ON placement_records
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := placement_seq.NEXTVAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_admission_id
    BEFORE INSERT ON admission_applications
    FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        :NEW.id := admission_seq.NEXTVAL;
    END IF;
END;
/

-- Create triggers for updating timestamps
CREATE OR REPLACE TRIGGER trg_dept_update
    BEFORE UPDATE ON departments
    FOR EACH ROW
BEGIN
    :NEW.updated_date := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_user_update
    BEFORE UPDATE ON users
    FOR EACH ROW
BEGIN
    :NEW.updated_date := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_student_update
    BEFORE UPDATE ON students
    FOR EACH ROW
BEGIN
    :NEW.updated_date := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_faculty_update
    BEFORE UPDATE ON faculty
    FOR EACH ROW
BEGIN
    :NEW.updated_date := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_course_update
    BEFORE UPDATE ON courses
    FOR EACH ROW
BEGIN
    :NEW.updated_date := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_result_update
    BEFORE UPDATE ON results
    FOR EACH ROW
BEGIN
    :NEW.updated_date := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_placement_update
    BEFORE UPDATE ON placement_records
    FOR EACH ROW
BEGIN
    :NEW.updated_date := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER trg_admission_update
    BEFORE UPDATE ON admission_applications
    FOR EACH ROW
BEGIN
    :NEW.updated_date := CURRENT_TIMESTAMP;
END;
/

COMMIT;