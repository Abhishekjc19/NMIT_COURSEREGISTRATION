-- Add IS_ACTIVE column to users table
ALTER TABLE users ADD is_active NUMBER(1) DEFAULT 1;

-- Verify the column was added
SELECT 'IS_ACTIVE column added successfully!' AS status FROM dual;

-- Show all columns
SELECT column_name FROM user_tab_columns WHERE table_name = 'USERS' ORDER BY column_id;

COMMIT;
