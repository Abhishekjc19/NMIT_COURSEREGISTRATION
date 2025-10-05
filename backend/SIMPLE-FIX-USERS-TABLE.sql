-- Simple verification and fix for USERS table
-- Run this in SQL Developer or Oracle SQL extension

SET SERVEROUTPUT ON;

-- Show current columns
SELECT 'CURRENT COLUMNS IN USERS TABLE:' AS info FROM dual;
SELECT column_name, data_type 
FROM user_tab_columns 
WHERE table_name = 'USERS'
ORDER BY column_id;

-- Add missing columns if they don't exist
-- TOKEN_EXPIRY
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE users ADD token_expiry TIMESTAMP';
    DBMS_OUTPUT.PUT_LINE('Added TOKEN_EXPIRY column');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1430 THEN
            DBMS_OUTPUT.PUT_LINE('TOKEN_EXPIRY already exists');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        END IF;
END;
/

-- PASSWORD_RESET_TOKEN
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE users ADD password_reset_token VARCHAR2(255)';
    DBMS_OUTPUT.PUT_LINE('Added PASSWORD_RESET_TOKEN column');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1430 THEN
            DBMS_OUTPUT.PUT_LINE('PASSWORD_RESET_TOKEN already exists');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        END IF;
END;
/

-- EMAIL_VERIFICATION_TOKEN
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE users ADD email_verification_token VARCHAR2(255)';
    DBMS_OUTPUT.PUT_LINE('Added EMAIL_VERIFICATION_TOKEN column');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1430 THEN
            DBMS_OUTPUT.PUT_LINE('EMAIL_VERIFICATION_TOKEN already exists');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        END IF;
END;
/

-- IS_EMAIL_VERIFIED
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE users ADD is_email_verified NUMBER(1) DEFAULT 0';
    DBMS_OUTPUT.PUT_LINE('Added IS_EMAIL_VERIFIED column');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1430 THEN
            DBMS_OUTPUT.PUT_LINE('IS_EMAIL_VERIFIED already exists');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        END IF;
END;
/

-- LAST_LOGIN
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE users ADD last_login TIMESTAMP';
    DBMS_OUTPUT.PUT_LINE('Added LAST_LOGIN column');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1430 THEN
            DBMS_OUTPUT.PUT_LINE('LAST_LOGIN already exists');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        END IF;
END;
/

-- Show updated columns
SELECT 'UPDATED COLUMNS IN USERS TABLE:' AS info FROM dual;
SELECT column_name, data_type 
FROM user_tab_columns 
WHERE table_name = 'USERS'
ORDER BY column_id;

COMMIT;
