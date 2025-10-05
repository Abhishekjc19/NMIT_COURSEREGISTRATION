-- QUICK FIX FOR USERS TABLE
-- Just run this entire file after connecting to the database

-- Add TOKEN_EXPIRY column
ALTER TABLE users ADD token_expiry TIMESTAMP;

-- Add PASSWORD_RESET_TOKEN column
ALTER TABLE users ADD password_reset_token VARCHAR2(255);

-- Add EMAIL_VERIFICATION_TOKEN column
ALTER TABLE users ADD email_verification_token VARCHAR2(255);

-- Add IS_EMAIL_VERIFIED column
ALTER TABLE users ADD is_email_verified NUMBER(1) DEFAULT 0;

-- Add LAST_LOGIN column
ALTER TABLE users ADD last_login TIMESTAMP;

-- Show all columns to verify
SELECT column_name, data_type 
FROM user_tab_columns 
WHERE table_name = 'USERS'
ORDER BY column_id;

-- Commit changes
COMMIT;
