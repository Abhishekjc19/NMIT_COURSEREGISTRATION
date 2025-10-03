@echo off
echo ==========================================
echo NMIT Portal Database Setup
echo ==========================================
echo.

echo Step 1: Creating application user...
echo Note: Using SYSTEM password with @ symbol

REM Create a temporary SQL file with the connection
echo CONNECT system/"808801@Abhi"@localhost:1521/FREE > temp_connect.sql
echo SELECT 'Connected as: ' ^|^| USER ^|^| ' on service: ' ^|^| SYS_CONTEXT('USERENV', 'SERVICE_NAME') FROM DUAL; >> temp_connect.sql
echo @@src\main\resources\db\sql-developer-setup.sql >> temp_connect.sql
echo QUIT >> temp_connect.sql

REM Run the connection script
sqlplus /nolog @temp_connect.sql

REM Clean up
del temp_connect.sql

echo.
echo Step 2: Setting up application schema...
echo Creating temporary script for app user...

REM Create app user script
echo CONNECT nmit_portal/nmit_portal_password@localhost:1521/FREE > temp_app.sql
echo SELECT 'Connected as: ' ^|^| USER FROM DUAL; >> temp_app.sql
echo @@src\main\resources\db\schema.sql >> temp_app.sql
echo @@src\main\resources\db\sample-data.sql >> temp_app.sql
echo @@src\main\resources\db\verify-setup.sql >> temp_app.sql
echo QUIT >> temp_app.sql

REM Run app setup
sqlplus /nolog @temp_app.sql

REM Clean up
del temp_app.sql

echo.
echo ==========================================
echo Database setup complete!
echo ==========================================
echo.
echo You can now start the Spring Boot application:
echo mvn spring-boot:run -Dspring.profiles.active=local
echo.
pause