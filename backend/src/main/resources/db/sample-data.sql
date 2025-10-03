-- NMIT Portal Sample Data
-- Run this script after creating the schema

-- Insert sample departments
INSERT INTO departments (code, name, description, head_of_department, created_by) VALUES
('CSE', 'Computer Science and Engineering', 'Department of Computer Science and Engineering', 'Dr. Rajesh Kumar', 'ADMIN');

INSERT INTO departments (code, name, description, head_of_department, created_by) VALUES
('ECE', 'Electronics and Communication Engineering', 'Department of Electronics and Communication Engineering', 'Dr. Priya Sharma', 'ADMIN');

INSERT INTO departments (code, name, description, head_of_department, created_by) VALUES
('ME', 'Mechanical Engineering', 'Department of Mechanical Engineering', 'Dr. Amit Singh', 'ADMIN');

INSERT INTO departments (code, name, description, head_of_department, created_by) VALUES
('CE', 'Civil Engineering', 'Department of Civil Engineering', 'Dr. Sunita Rao', 'ADMIN');

INSERT INTO departments (code, name, description, head_of_department, created_by) VALUES
('EEE', 'Electrical and Electronics Engineering', 'Department of Electrical and Electronics Engineering', 'Dr. Vikram Gupta', 'ADMIN');

-- Insert sample admin user (password: admin123)
INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) VALUES
('admin', 'admin@nmit.edu.in', '$2a$10$X5wFWtY8fQKJ7Xx4ZQtW4.rBV8nh9QqKGKp2yPFj7QnVqUzm7sGtC', 'Admin', 'User', '9876543210', 'ADMIN', 1, 'SYSTEM');

-- Insert sample HOD users (password: hod123)
INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) VALUES
('hod_cse', 'hod.cse@nmit.edu.in', '$2a$10$Y6xGXuZ9gRLK8Yy5AQvX5.sCW9oi0RrLHLq3zQGk8RoVrVzn8tHvD', 'Rajesh', 'Kumar', '9876543211', 'HOD', 1, 'ADMIN');

INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) VALUES
('hod_ece', 'hod.ece@nmit.edu.in', '$2a$10$Z7yHYvA0hSML9Zz6BRwY6.tDX0pj1SsMIMs4ARHl9SpWsWzo9uIwE', 'Priya', 'Sharma', '9876543212', 'HOD', 1, 'ADMIN');

-- Insert sample faculty users (password: faculty123)
INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) VALUES
('faculty001', 'faculty001@nmit.edu.in', '$2a$10$A8zIZwB1iTNM0Az7CSxZ7.uEY1qk2TtNJNt5BSIm0TqXtXzp0vJxF', 'Suresh', 'Reddy', '9876543213', 'FACULTY', 1, 'ADMIN');

INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) VALUES
('faculty002', 'faculty002@nmit.edu.in', '$2a$10$B9AJAxC2jUON1BA8DTyA8.vFZ2rl3UuOKOu6CTJn1UrYuYAq1wKyG', 'Manjula', 'Devi', '9876543214', 'FACULTY', 1, 'ADMIN');

-- Insert sample student users (password: student123)
INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) VALUES
('4nm20cs001', '4nm20cs001@nmit.edu.in', '$2a$10$C0BJByD3kVPO2CB9EUzB9.wGZ3sm4VvPLPv7DUKo2VsZvZBr2xLzH', 'Aarav', 'Kumar', '9876543215', 'STUDENT', 1, 'ADMIN');

INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) VALUES
('4nm20cs002', '4nm20cs002@nmit.edu.in', '$2a$10$D1CKCzE4lWQP3DC0FVzC0.xHZ4tn5WwQMQw8EVLp3WtAwACr3yMzI', 'Bhavya', 'Sharma', '9876543216', 'STUDENT', 1, 'ADMIN');

INSERT INTO users (username, email, password, first_name, last_name, phone_number, role, is_email_verified, created_by) VALUES
('4nm20cs003', '4nm20cs003@nmit.edu.in', '$2a$10$E2DLDAf5mXRQ4ED1GWzD1.yIZ5uo6XxRNRx9FWMq4XuBxBDs4zNzJ', 'Chitra', 'Reddy', '9876543217', 'STUDENT', 1, 'ADMIN');

-- Insert faculty records
INSERT INTO faculty (user_id, department_id, employee_id, designation, qualification, experience_years, specialization, date_of_joining, office_room, created_by) VALUES
((SELECT id FROM users WHERE username = 'faculty001'), (SELECT id FROM departments WHERE code = 'CSE'), 'FAC001', 'Associate Professor', 'Ph.D in Computer Science', 8, 'Machine Learning, Data Science', DATE '2016-07-01', 'CSE-201', 'ADMIN');

INSERT INTO faculty (user_id, department_id, employee_id, designation, qualification, experience_years, specialization, date_of_joining, office_room, created_by) VALUES
((SELECT id FROM users WHERE username = 'faculty002'), (SELECT id FROM departments WHERE code = 'CSE'), 'FAC002', 'Assistant Professor', 'M.Tech in Computer Science', 5, 'Web Development, Database Systems', DATE '2019-08-01', 'CSE-202', 'ADMIN');

-- Insert student records
INSERT INTO students (user_id, department_id, usn, admission_number, batch_year, current_semester, cgpa, date_of_birth, gender, address, parent_name, parent_phone, parent_email, admission_date, status, created_by) VALUES
((SELECT id FROM users WHERE username = '4nm20cs001'), (SELECT id FROM departments WHERE code = 'CSE'), '4NM20CS001', 'ADM2020001', 2020, 8, 8.5, DATE '2002-03-15', 'Male', '123 Main Street, Bangalore', 'Ramesh Kumar', '9876543100', 'ramesh.kumar@gmail.com', DATE '2020-08-01', 'ACTIVE', 'ADMIN');

INSERT INTO students (user_id, department_id, usn, admission_number, batch_year, current_semester, cgpa, date_of_birth, gender, address, parent_name, parent_phone, parent_email, admission_date, status, created_by) VALUES
((SELECT id FROM users WHERE username = '4nm20cs002'), (SELECT id FROM departments WHERE code = 'CSE'), '4NM20CS002', 'ADM2020002', 2020, 8, 9.1, DATE '2002-05-20', 'Female', '456 Park Avenue, Bangalore', 'Suresh Sharma', '9876543101', 'suresh.sharma@gmail.com', DATE '2020-08-01', 'ACTIVE', 'ADMIN');

INSERT INTO students (user_id, department_id, usn, admission_number, batch_year, current_semester, cgpa, date_of_birth, gender, address, parent_name, parent_phone, parent_email, admission_date, status, created_by) VALUES
((SELECT id FROM users WHERE username = '4nm20cs003'), (SELECT id FROM departments WHERE code = 'CSE'), '4NM20CS003', 'ADM2020003', 2020, 8, 7.8, DATE '2002-01-10', 'Female', '789 Lake View, Bangalore', 'Mohan Reddy', '9876543102', 'mohan.reddy@gmail.com', DATE '2020-08-01', 'ACTIVE', 'ADMIN');

-- Insert sample courses
INSERT INTO courses (department_id, faculty_id, course_code, course_name, credits, semester, course_type, description, created_by) VALUES
((SELECT id FROM departments WHERE code = 'CSE'), (SELECT id FROM faculty WHERE employee_id = 'FAC001'), 'CS501', 'Machine Learning', 4, 5, 'Theory', 'Introduction to Machine Learning algorithms and applications', 'ADMIN');

INSERT INTO courses (department_id, faculty_id, course_code, course_name, credits, semester, course_type, description, created_by) VALUES
((SELECT id FROM departments WHERE code = 'CSE'), (SELECT id FROM faculty WHERE employee_id = 'FAC002'), 'CS502', 'Database Management Systems', 4, 5, 'Theory', 'Relational database design and SQL programming', 'ADMIN');

INSERT INTO courses (department_id, faculty_id, course_code, course_name, credits, semester, course_type, description, created_by) VALUES
((SELECT id FROM departments WHERE code = 'CSE'), (SELECT id FROM faculty WHERE employee_id = 'FAC001'), 'CS503', 'Data Structures and Algorithms', 4, 3, 'Theory', 'Fundamental data structures and algorithmic techniques', 'ADMIN');

INSERT INTO courses (department_id, faculty_id, course_code, course_name, credits, semester, course_type, description, created_by) VALUES
((SELECT id FROM departments WHERE code = 'CSE'), (SELECT id FROM faculty WHERE employee_id = 'FAC002'), 'CS504', 'Web Technologies', 3, 6, 'Theory', 'Modern web development frameworks and technologies', 'ADMIN');

-- Insert sample results
INSERT INTO results (student_id, course_id, internal_marks, external_marks, total_marks, grade, grade_points, exam_type, academic_year, result_status, created_by) VALUES
((SELECT id FROM students WHERE usn = '4NM20CS001'), (SELECT id FROM courses WHERE course_code = 'CS501'), 18, 72, 90, 'O', 10.0, 'Regular', '2023-24', 'Pass', 'FACULTY');

INSERT INTO results (student_id, course_id, internal_marks, external_marks, total_marks, grade, grade_points, exam_type, academic_year, result_status, created_by) VALUES
((SELECT id FROM students WHERE usn = '4NM20CS002'), (SELECT id FROM courses WHERE course_code = 'CS501'), 19, 76, 95, 'O', 10.0, 'Regular', '2023-24', 'Pass', 'FACULTY');

INSERT INTO results (student_id, course_id, internal_marks, external_marks, total_marks, grade, grade_points, exam_type, academic_year, result_status, created_by) VALUES
((SELECT id FROM students WHERE usn = '4NM20CS003'), (SELECT id FROM courses WHERE course_code = 'CS501'), 16, 68, 84, 'A+', 9.0, 'Regular', '2023-24', 'Pass', 'FACULTY');

INSERT INTO results (student_id, course_id, internal_marks, external_marks, total_marks, grade, grade_points, exam_type, academic_year, result_status, created_by) VALUES
((SELECT id FROM students WHERE usn = '4NM20CS001'), (SELECT id FROM courses WHERE course_code = 'CS502'), 17, 70, 87, 'A+', 9.0, 'Regular', '2023-24', 'Pass', 'FACULTY');

INSERT INTO results (student_id, course_id, internal_marks, external_marks, total_marks, grade, grade_points, exam_type, academic_year, result_status, created_by) VALUES
((SELECT id FROM students WHERE usn = '4NM20CS002'), (SELECT id FROM courses WHERE course_code = 'CS502'), 20, 78, 98, 'O', 10.0, 'Regular', '2023-24', 'Pass', 'FACULTY');

-- Insert sample placement records
INSERT INTO placement_records (student_id, company_name, job_title, package_offered, job_location, placement_date, offer_letter_date, placement_type, status, company_category, created_by) VALUES
((SELECT id FROM students WHERE usn = '4NM20CS002'), 'TCS', 'Software Engineer', 350000, 'Bangalore', DATE '2024-02-15', DATE '2024-02-10', 'Campus', 'Placed', 'Service', 'PLACEMENT_OFFICER');

INSERT INTO placement_records (student_id, company_name, job_title, package_offered, job_location, placement_date, offer_letter_date, placement_type, status, company_category, created_by) VALUES
((SELECT id FROM students WHERE usn = '4NM20CS001'), 'Infosys', 'System Engineer', 320000, 'Mysore', DATE '2024-03-01', DATE '2024-02-25', 'Campus', 'Placed', 'Service', 'PLACEMENT_OFFICER');

-- Insert sample admission applications
INSERT INTO admission_applications (department_id, application_number, applicant_name, email, phone_number, date_of_birth, gender, course_applied, entrance_exam_score, class_12_percentage, class_10_percentage, application_status, application_date, parent_name, parent_phone, created_by) VALUES
((SELECT id FROM departments WHERE code = 'CSE'), 'APP2024001', 'Arjun Prakash', 'arjun.prakash@gmail.com', '9876543300', DATE '2006-04-12', 'Male', 'B.Tech Computer Science', 85.5, 92.5, 89.0, 'Under Review', DATE '2024-03-15', 'Prakash Kumar', '9876543301', 'ADMIN');

INSERT INTO admission_applications (department_id, application_number, applicant_name, email, phone_number, date_of_birth, gender, course_applied, entrance_exam_score, class_12_percentage, class_10_percentage, application_status, application_date, parent_name, parent_phone, created_by) VALUES
((SELECT id FROM departments WHERE code = 'ECE'), 'APP2024002', 'Sneha Rao', 'sneha.rao@gmail.com', '9876543302', DATE '2006-06-18', 'Female', 'B.Tech Electronics', 88.0, 94.0, 91.5, 'Approved', DATE '2024-03-20', 'Ravi Rao', '9876543303', 'ADMIN');

INSERT INTO admission_applications (department_id, application_number, applicant_name, email, phone_number, date_of_birth, gender, course_applied, entrance_exam_score, class_12_percentage, class_10_percentage, application_status, application_date, parent_name, parent_phone, created_by) VALUES
((SELECT id FROM departments WHERE code = 'ME'), 'APP2024003', 'Kiran Singh', 'kiran.singh@gmail.com', '9876543304', DATE '2006-02-25', 'Male', 'B.Tech Mechanical', 82.0, 87.5, 85.0, 'Under Review', DATE '2024-03-25', 'Vijay Singh', '9876543305', 'ADMIN');

COMMIT;

-- Display sample data verification
SELECT 'Departments Count: ' || COUNT(*) FROM departments;
SELECT 'Users Count: ' || COUNT(*) FROM users;
SELECT 'Students Count: ' || COUNT(*) FROM students;
SELECT 'Faculty Count: ' || COUNT(*) FROM faculty;
SELECT 'Courses Count: ' || COUNT(*) FROM courses;
SELECT 'Results Count: ' || COUNT(*) FROM results;
SELECT 'Placement Records Count: ' || COUNT(*) FROM placement_records;
SELECT 'Admission Applications Count: ' || COUNT(*) FROM admission_applications;