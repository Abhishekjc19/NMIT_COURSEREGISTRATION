-- Oracle Connection Script for SYSTEM user with special characters in password
-- This script handles the @ symbol in the password properly

-- Connect to Oracle as SYSTEM
CONNECT system/"808801@Abhi"@localhost:1521/FREE

-- Verify connection
SELECT 'Connected to Oracle as: ' || USER || ' on service: ' || SYS_CONTEXT('USERENV', 'SERVICE_NAME') FROM DUAL;

-- Show database version
SELECT banner FROM v$version WHERE ROWNUM = 1;

-- Run the user setup script
PROMPT ==========================================
PROMPT Creating NMIT Portal Application User...
PROMPT ==========================================

@@sql-developer-setup.sql

-- Verify user creation
PROMPT ==========================================
PROMPT Verifying user creation...
PROMPT ==========================================

SELECT username, account_status, default_tablespace 
FROM dba_users 
WHERE username = 'NMIT_PORTAL';

PROMPT ==========================================
PROMPT User creation complete!
PROMPT ==========================================
PROMPT Next steps:
PROMPT 1. Connect as nmit_portal user
PROMPT 2. Run schema.sql
PROMPT 3. Run sample-data.sql
PROMPT ==========================================

QUIT