-- Check actual columns in users table
SELECT column_name, data_type, nullable 
FROM user_tab_columns 
WHERE table_name = 'USERS'
ORDER BY column_id;
