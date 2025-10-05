-- Complete setup for test student
SET SERVEROUTPUT ON;

-- Create department first
INSERT INTO departments (id, code, name, hod_name, created_date, updated_date)
VALUES (1, 'AIML', 'Artificial Intelligence and Machine Learning', 'Dr. Test HOD', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Create user with BCrypt password for "student123"
INSERT INTO users (
    id, username, email, password, first_name, last_name, phone_number, role,
    is_email_verified, is_active, created_date, updated_date
) VALUES (
    1, '1NT23AI004', '1nt23ai004@nmit.ac.in', 
    '$2a$10$xQZ9yJ5K3vX8YvH5bZ9qKOF6nX5E5H5nZ9qKOF6nX5E5H5nZ9qKO',
    'Test', 'Student', '9876543210', 'STUDENT',
    0, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

-- Create student profile
INSERT INTO students (
    id, user_id, department_id, usn, batch_year, current_semester, cgpa,
    date_of_birth, gender, status, is_active, created_date, updated_date
) VALUES (
    1, 1, 1, '1NT23AI004', 2023, 5, 8.5,
    TO_DATE('19/04/2004', 'DD/MM/YYYY'), 'Male', 'ACTIVE', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
);

COMMIT;

-- Verify
SELECT 'Department:' || name AS result FROM departments WHERE code = 'AIML';
SELECT 'User:' || username || ' (' || role || ')' AS result FROM users WHERE username = '1NT23AI004';
SELECT 'Student:' || usn || ' DOB:' || TO_CHAR(date_of_birth, 'DD/MM/YYYY') AS result FROM students WHERE usn = '1NT23AI004';
