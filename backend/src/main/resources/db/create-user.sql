-- Oracle Database Setup Script
-- Run this as SYSTEM or SYS user

-- Create tablespace for NMIT Portal (Optional but recommended)
CREATE TABLESPACE nmit_portal_data
    DATAFILE 'nmit_portal_data01.dbf' SIZE 100M
    AUTOEXTEND ON NEXT 10M MAXSIZE 1G
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- Create user for NMIT Portal application
CREATE USER nmit_portal IDENTIFIED BY nmit_portal_password
    DEFAULT TABLESPACE nmit_portal_data
    TEMPORARY TABLESPACE temp
    QUOTA UNLIMITED ON nmit_portal_data;

-- Grant necessary privileges
GRANT CONNECT TO nmit_portal;
GRANT RESOURCE TO nmit_portal;
GRANT CREATE SESSION TO nmit_portal;
GRANT CREATE TABLE TO nmit_portal;
GRANT CREATE VIEW TO nmit_portal;
GRANT CREATE SEQUENCE TO nmit_portal;
GRANT CREATE TRIGGER TO nmit_portal;
GRANT CREATE PROCEDURE TO nmit_portal;

-- Additional privileges for development
GRANT CREATE ANY INDEX TO nmit_portal;
GRANT ALTER ANY TABLE TO nmit_portal;
GRANT DROP ANY TABLE TO nmit_portal;

-- Verify user creation
SELECT username, default_tablespace, temporary_tablespace 
FROM dba_users 
WHERE username = 'NMIT_PORTAL';

-- Test connection
CONNECT nmit_portal/nmit_portal_password;
SELECT USER FROM DUAL;