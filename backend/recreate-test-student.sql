-- Recreate test student user and data
-- BCrypt hash for password "student123"
DECLARE
    v_user_id NUMBER;
    v_dept_id NUMBER;
    v_password VARCHAR2(120) := '$2a$10$xQZ9yJ5K3vX8YvH5bZ9qKOF6nX5E5H5nZ9qKOF6nX5E5H5nZ9qKO';
BEGIN
    -- Get department ID (should exist)
    SELECT id INTO v_dept_id FROM departments WHERE code = 'AIML' AND ROWNUM = 1;
    
    -- Insert User
    INSERT INTO users (
        id, username, email, password, first_name, last_name, phone_number, role,
        is_email_verified, is_active, created_date, updated_date
    ) VALUES (
        1, '1NT23AI004', '1nt23ai004@nmit.ac.in', v_password, 'Test', 'Student', '9876543210', 'STUDENT',
        0, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    );
    
    v_user_id := 1;
    
    -- Insert Student
    INSERT INTO students (
        id, user_id, department_id, usn, batch_year, current_semester, cgpa,
        date_of_birth, gender, status, is_active, created_date, updated_date
    ) VALUES (
        1, v_user_id, v_dept_id, '1NT23AI004', 2023, 5, 8.5,
        TO_DATE('19/04/2004', 'DD/MM/YYYY'), 'Male', 'ACTIVE', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
    );
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Test student created successfully!');
    DBMS_OUTPUT.PUT_LINE('USN: 1NT23AI004');
    DBMS_OUTPUT.PUT_LINE('DOB: 19/04/2004');
    DBMS_OUTPUT.PUT_LINE('Password: student123');
END;
/

-- Verify creation
SELECT 'User created:' AS info FROM dual;
SELECT username, email, role FROM users WHERE username = '1NT23AI004';

SELECT 'Student created:' AS info FROM dual;
SELECT usn, date_of_birth FROM students WHERE usn = '1NT23AI004';
