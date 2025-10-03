-- Application User Connection and Schema Setup
-- Run this after creating the nmit_portal user

-- Connect as the application user
CONNECT nmit_portal/nmit_portal_password@localhost:1521/FREE

-- Verify connection
SELECT 'Connected as: ' || USER || ' on service: ' || SYS_CONTEXT('USERENV', 'SERVICE_NAME') FROM DUAL;

-- Create the schema
PROMPT ==========================================
PROMPT Creating NMIT Portal Database Schema...
PROMPT ==========================================

@@schema.sql

-- Insert sample data
PROMPT ==========================================
PROMPT Inserting Sample Data...
PROMPT ==========================================

@@sample-data.sql

-- Verify setup
PROMPT ==========================================
PROMPT Verifying Database Setup...
PROMPT ==========================================

@@verify-setup.sql

PROMPT ==========================================
PROMPT Database setup complete!
PROMPT ==========================================
PROMPT You can now start the Spring Boot application:
PROMPT cd C:\NMIT_PORTAL\backend
PROMPT mvn spring-boot:run -Dspring.profiles.active=local
PROMPT ==========================================

QUIT