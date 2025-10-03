@echo off
echo ==========================================
echo NMIT Portal Database Status Check
echo ==========================================
echo.

echo Checking if nmit_portal user can connect...
echo Testing connection to Oracle XE with service name FREE...
echo.

REM Test application user connection
echo Testing nmit_portal user connection:
echo connect nmit_portal/nmit_portal_password@localhost:1521/FREE > temp_test.sql
echo SELECT 'SUCCESS: Connected as ' ^|^| USER ^|^| ' to service ' ^|^| SYS_CONTEXT('USERENV', 'SERVICE_NAME') FROM DUAL; >> temp_test.sql
echo SELECT 'Database tables count: ' ^|^| COUNT(*) FROM user_tables; >> temp_test.sql
echo SELECT table_name FROM user_tables ORDER BY table_name; >> temp_test.sql
echo QUIT >> temp_test.sql

sqlplus /nolog @temp_test.sql

del temp_test.sql

echo.
echo ==========================================
echo If you see table names above, your database is ready!
echo If you see connection errors, you need to set up the database first.
echo ==========================================
pause