-- Check if nmit_portal user exists and its status
-- Run this in SYSTEM connection in SQL Developer

-- 1. Check if user exists
SELECT username, account_status, default_tablespace, created
FROM dba_users 
WHERE username = 'NMIT_PORTAL';

-- 2. If user doesn't exist or is locked, create/unlock it
-- CREATE USER nmit_portal IDENTIFIED BY nmit_portal_password;
-- ALTER USER nmit_portal ACCOUNT UNLOCK;

-- 3. Grant necessary privileges
-- GRANT CONNECT, RESOURCE, CREATE SESSION TO nmit_portal;
-- GRANT CREATE TABLE, CREATE SEQUENCE, CREATE VIEW TO nmit_portal;
-- GRANT UNLIMITED TABLESPACE TO nmit_portal;

-- 4. Test connection as nmit_portal user
-- After running above, try connecting as:
-- Username: nmit_portal
-- Password: nmit_portal_password
-- Service: FREE