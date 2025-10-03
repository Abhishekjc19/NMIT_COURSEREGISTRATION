@echo off
echo ==========================================
echo NMIT Portal Schema and Data Setup
echo ==========================================
echo.

echo Step 1: Creating database schema...
echo connect nmit_portal/nmit_portal_password@localhost:1521/FREE > setup_schema.sql
echo WHENEVER SQLERROR EXIT SQL.SQLCODE >> setup_schema.sql
echo @src\main\resources\db\schema.sql >> setup_schema.sql
echo SELECT 'Schema creation completed!' FROM DUAL; >> setup_schema.sql
echo QUIT >> setup_schema.sql

echo Running schema creation...
sqlplus /nolog @setup_schema.sql

if %errorlevel% neq 0 (
    echo ❌ Schema creation failed. Please check the error above.
    del setup_schema.sql
    pause
    exit /b 1
)

echo.
echo Step 2: Inserting sample data...
echo connect nmit_portal/nmit_portal_password@localhost:1521/FREE > setup_data.sql
echo WHENEVER SQLERROR EXIT SQL.SQLCODE >> setup_data.sql
echo @src\main\resources\db\sample-data.sql >> setup_data.sql
echo SELECT 'Sample data insertion completed!' FROM DUAL; >> setup_data.sql
echo QUIT >> setup_data.sql

echo Running sample data insertion...
sqlplus /nolog @setup_data.sql

if %errorlevel% neq 0 (
    echo ❌ Sample data insertion failed. Please check the error above.
    del setup_schema.sql
    del setup_data.sql
    pause
    exit /b 1
)

echo.
echo Step 3: Verifying setup...
echo connect nmit_portal/nmit_portal_password@localhost:1521/FREE > verify_setup.sql
echo @src\main\resources\db\verify-setup.sql >> verify_setup.sql
echo QUIT >> verify_setup.sql

echo Running verification...
sqlplus /nolog @verify_setup.sql

REM Clean up temporary files
del setup_schema.sql
del setup_data.sql  
del verify_setup.sql

echo.
echo ==========================================
echo ✅ Database setup completed!
echo ==========================================
echo.
echo Next step: Install Maven and run the application
echo Download Maven from: https://maven.apache.org/download.cgi
echo.
echo After installing Maven, run:
echo   mvn spring-boot:run -Dspring.profiles.active=local
echo.
pause