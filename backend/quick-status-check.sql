CONNECT nmit_portal/nmit_portal_password@localhost:1521/FREE
SELECT 'Database Connection: SUCCESS' as status FROM DUAL;
SELECT 'Connected as: ' || USER as current_user FROM DUAL;
SELECT 'Service: ' || SYS_CONTEXT('USERENV', 'SERVICE_NAME') as service_name FROM DUAL;

-- Check if tables exist
SELECT 'Tables Count: ' || COUNT(*) as table_count FROM user_tables;

-- List all tables if they exist
SELECT table_name FROM user_tables ORDER BY table_name;

-- Check sequences
SELECT 'Sequences Count: ' || COUNT(*) as sequence_count FROM user_sequences;

-- Check sample data
SELECT 'Users Count: ' || COUNT(*) as users_count FROM users WHERE ROWNUM <= 1;
SELECT 'Students Count: ' || COUNT(*) as students_count FROM students WHERE ROWNUM <= 1;
SELECT 'Faculty Count: ' || COUNT(*) as faculty_count FROM faculty WHERE ROWNUM <= 1;

QUIT