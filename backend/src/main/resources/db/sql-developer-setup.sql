-- NMIT Portal Database User Setup for SQL Developer 23 AI
-- Execute this script as SYSTEM user

-- Step 1: Create tablespace (Optional but recommended for better organization)
CREATE TABLESPACE NMIT_PORTAL_DATA
    DATAFILE 'nmit_portal_data01.dbf' SIZE 100M
    AUTOEXTEND ON NEXT 10M MAXSIZE 2G
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- Step 2: Create application user
CREATE USER nmit_portal IDENTIFIED BY nmit_portal_password
    DEFAULT TABLESPACE NMIT_PORTAL_DATA
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON NMIT_PORTAL_DATA;

-- Step 3: Grant essential privileges
GRANT CONNECT TO nmit_portal;
GRANT RESOURCE TO nmit_portal;
GRANT CREATE SESSION TO nmit_portal;
GRANT CREATE TABLE TO nmit_portal;
GRANT CREATE VIEW TO nmit_portal;
GRANT CREATE SEQUENCE TO nmit_portal;
GRANT CREATE TRIGGER TO nmit_portal;
GRANT CREATE PROCEDURE TO nmit_portal;
GRANT CREATE SYNONYM TO nmit_portal;

-- Step 4: Additional development privileges
GRANT CREATE ANY INDEX TO nmit_portal;
GRANT ALTER ANY TABLE TO nmit_portal;
GRANT DROP ANY TABLE TO nmit_portal;
GRANT SELECT ANY DICTIONARY TO nmit_portal;

-- Step 5: Grant system privileges for sequences and triggers
GRANT CREATE ANY SEQUENCE TO nmit_portal;
GRANT CREATE ANY TRIGGER TO nmit_portal;

-- Step 6: Verify user creation
SELECT 
    username,
    default_tablespace,
    temporary_tablespace,
    account_status,
    created
FROM dba_users 
WHERE username = 'NMIT_PORTAL';

-- Step 7: Check granted privileges
SELECT 
    grantee,
    privilege,
    admin_option
FROM dba_sys_privs 
WHERE grantee = 'NMIT_PORTAL'
ORDER BY privilege;

-- Success message
SELECT 'NMIT Portal user created successfully!' as STATUS FROM DUAL;

COMMIT;