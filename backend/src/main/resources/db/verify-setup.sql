-- NMIT Portal Database Verification Script
-- For Oracle XE with Service Name "FREE"
-- Run this script in NMIT_Portal_App connection to verify setup

PROMPT =====================================
PROMPT NMIT Portal Setup Verification
PROMPT =====================================

-- Test 1: Connection and Service Name
PROMPT
PROMPT Test 1: Database Connection Info
SELECT 
    'Connected as: ' || USER as user_info,
    'Database: ' || SYS_CONTEXT('USERENV', 'DB_NAME') as database_info,
    'Service: ' || SYS_CONTEXT('USERENV', 'SERVICE_NAME') as service_info,
    'Oracle Version: ' || (SELECT banner FROM v$version WHERE ROWNUM = 1) as version_info
FROM DUAL;

-- Test 2: Check all tables are created
PROMPT
PROMPT Test 2: Application Tables
SELECT 
    table_name,
    num_rows,
    last_analyzed
FROM user_tables 
ORDER BY table_name;

-- Check sequences
SELECT 
    sequence_name,
    min_value,
    max_value,
    increment_by,
    last_number
FROM user_sequences
ORDER BY sequence_name;

-- Check triggers
SELECT 
    trigger_name,
    table_name,
    triggering_event,
    status
FROM user_triggers
ORDER BY table_name, trigger_name;

-- Verify sample data counts
SELECT 'Departments' as TABLE_NAME, COUNT(*) as RECORD_COUNT FROM departments
UNION ALL
SELECT 'Users', COUNT(*) FROM users
UNION ALL
SELECT 'Students', COUNT(*) FROM students
UNION ALL
SELECT 'Faculty', COUNT(*) FROM faculty
UNION ALL
SELECT 'Courses', COUNT(*) FROM courses
UNION ALL
SELECT 'Results', COUNT(*) FROM results
UNION ALL
SELECT 'Placement Records', COUNT(*) FROM placement_records
UNION ALL
SELECT 'Admission Applications', COUNT(*) FROM admission_applications
ORDER BY TABLE_NAME;

-- Check sample users with roles
SELECT 
    u.username,
    u.first_name || ' ' || u.last_name as full_name,
    u.email,
    u.role,
    u.is_email_verified,
    u.created_date
FROM users u
ORDER BY u.role, u.username;

-- Check student data
SELECT 
    s.usn,
    u.first_name || ' ' || u.last_name as student_name,
    d.name as department,
    s.batch_year,
    s.current_semester,
    s.cgpa
FROM students s
JOIN users u ON s.user_id = u.id
JOIN departments d ON s.department_id = d.id
ORDER BY s.usn;

-- Check constraints and foreign keys
SELECT 
    constraint_name,
    constraint_type,
    table_name,
    status
FROM user_constraints
WHERE constraint_type IN ('P', 'R', 'C', 'U')
ORDER BY table_name, constraint_type;

-- Database setup verification summary
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM user_tables) >= 8 
        AND (SELECT COUNT(*) FROM users) > 0
        AND (SELECT COUNT(*) FROM departments) > 0
        THEN '✅ Database setup completed successfully!'
        ELSE '❌ Database setup incomplete. Please check the logs above.'
    END as SETUP_STATUS
FROM DUAL;