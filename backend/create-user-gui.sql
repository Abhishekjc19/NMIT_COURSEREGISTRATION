-- Copy and paste this ENTIRE script into SQL Developer

-- Step 1: Check if user exists
SELECT username, account_status FROM dba_users WHERE username = 'NMIT_PORTAL';

-- Step 2: Drop user if exists (ignore errors)
BEGIN
    EXECUTE IMMEDIATE 'DROP USER nmit_portal CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('User does not exist or error: ' || SQLERRM);
END;
/

-- Step 3: Create user
CREATE USER nmit_portal IDENTIFIED BY "808801@AbhiDB";

-- Step 4: Grant privileges
GRANT CONNECT, RESOURCE, CREATE SESSION TO nmit_portal;
GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO nmit_portal;
GRANT UNLIMITED TABLESPACE TO nmit_portal;

-- Step 5: Verify user created
SELECT username, account_status, created FROM dba_users WHERE username = 'NMIT_PORTAL';

-- Success message
SELECT 'nmit_portal user created successfully!' as STATUS FROM dual;