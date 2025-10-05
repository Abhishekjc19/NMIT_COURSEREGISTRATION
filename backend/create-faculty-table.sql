-- Create FACULTY table
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

SELECT 'FACULTY table created successfully!' AS status FROM dual;

COMMIT;
