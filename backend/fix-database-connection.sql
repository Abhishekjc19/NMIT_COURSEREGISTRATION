-- Fix Database Connection Issues
-- Run this as SYSTEM user in SQL Developer or SQL*Plus

-- Connect as SYSTEM user
connect system/"808801@Abhi"@localhost:1521/FREE

-- Step 1: Check if user exists
SELECT username, account_status, created FROM dba_users WHERE username = 'NMIT_PORTAL';

-- Step 2: Drop user if exists (ignore errors if user doesn't exist)
-- DROP USER nmit_portal CASCADE;

-- Step 3: Create user with correct password
CREATE USER nmit_portal IDENTIFIED BY "808801@AbhiDB";

-- Step 4: Grant necessary privileges
GRANT CONNECT, RESOURCE, CREATE SESSION TO nmit_portal;
GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO nmit_portal;
GRANT UNLIMITED TABLESPACE TO nmit_portal;

-- Step 5: Verify user creation
SELECT username, account_status, created FROM dba_users WHERE username = 'NMIT_PORTAL';

-- Step 6: Test connection as new user
connect nmit_portal/"808801@AbhiDB"@localhost:1521/FREE
SELECT 'nmit_portal user connected successfully!' as status FROM dual;

exit