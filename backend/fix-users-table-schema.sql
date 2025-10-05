-- Fix Users Table Schema - Add any missing columns
-- Connect as nmit_portal user

-- Check if token_expiry column exists, if not add it
DECLARE
    v_column_exists NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_column_exists 
    FROM user_tab_columns 
    WHERE table_name = 'USERS' AND column_name = 'TOKEN_EXPIRY';
    
    IF v_column_exists = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE users ADD token_expiry TIMESTAMP';
        DBMS_OUTPUT.PUT_LINE('Added TOKEN_EXPIRY column');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TOKEN_EXPIRY column already exists');
    END IF;
END;
/

-- Check if password_reset_token exists
DECLARE
    v_column_exists NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_column_exists 
    FROM user_tab_columns 
    WHERE table_name = 'USERS' AND column_name = 'PASSWORD_RESET_TOKEN';
    
    IF v_column_exists = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE users ADD password_reset_token VARCHAR2(255)';
        DBMS_OUTPUT.PUT_LINE('Added PASSWORD_RESET_TOKEN column');
    ELSE
        DBMS_OUTPUT.PUT_LINE('PASSWORD_RESET_TOKEN column already exists');
    END IF;
END;
/

-- Check if email_verification_token exists
DECLARE
    v_column_exists NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_column_exists 
    FROM user_tab_columns 
    WHERE table_name = 'USERS' AND column_name = 'EMAIL_VERIFICATION_TOKEN';
    
    IF v_column_exists = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE users ADD email_verification_token VARCHAR2(255)';
        DBMS_OUTPUT.PUT_LINE('Added EMAIL_VERIFICATION_TOKEN column');
    ELSE
        DBMS_OUTPUT.PUT_LINE('EMAIL_VERIFICATION_TOKEN column already exists');
    END IF;
END;
/

-- Check if is_email_verified exists
DECLARE
    v_column_exists NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_column_exists 
    FROM user_tab_columns 
    WHERE table_name = 'USERS' AND column_name = 'IS_EMAIL_VERIFIED';
    
    IF v_column_exists = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE users ADD is_email_verified NUMBER(1) DEFAULT 0 CHECK (is_email_verified IN (0,1))';
        DBMS_OUTPUT.PUT_LINE('Added IS_EMAIL_VERIFIED column');
    ELSE
        DBMS_OUTPUT.PUT_LINE('IS_EMAIL_VERIFIED column already exists');
    END IF;
END;
/

-- Check if last_login exists
DECLARE
    v_column_exists NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_column_exists 
    FROM user_tab_columns 
    WHERE table_name = 'USERS' AND column_name = 'LAST_LOGIN';
    
    IF v_column_exists = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE users ADD last_login TIMESTAMP';
        DBMS_OUTPUT.PUT_LINE('Added LAST_LOGIN column');
    ELSE
        DBMS_OUTPUT.PUT_LINE('LAST_LOGIN column already exists');
    END IF;
END;
/

-- Verify all columns
SELECT 'Current USERS table structure:' AS info FROM dual;
SELECT column_name, data_type, nullable, data_default
FROM user_tab_columns 
WHERE table_name = 'USERS'
ORDER BY column_id;

COMMIT;
