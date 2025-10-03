@echo off
echo -- Test connection (you need to update the password)
echo 🔌 Testing Oracle connection...
echo Using SYSTEM password: 808801@Abhi
echo.

REM Create application user
echo 👤 Creating application user...
echo Note: Password contains @ symbol, using connection file
sqlplus /nolog @src\main\resources\db\connect-and-setup.sqlortal Backend Setup
echo ================================

REM Check if Oracle is running
echo 📋 Checking Oracle Database...

where sqlplus >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Oracle SQL*Plus not found. Please install Oracle Database first.
    echo    Download from: https://www.oracle.com/database/technologies/xe-downloads.html
    pause
    exit /b 1
)

echo ✅ Oracle SQL*Plus found

REM Test Oracle connection (you need to update the password)
echo 🔌 Testing Oracle connection...
echo Please make sure to update this script with your SYSTEM password
echo.

REM Create application user
echo 👤 Creating application user...
sqlplus system/your_system_password@localhost:1521/XE @src\main\resources\db\create-user.sql

if %errorlevel% neq 0 (
    echo ❌ Failed to create application user
    echo Please check:
    echo 1. Oracle Database is running
    echo 2. SYSTEM password is correct
    echo 3. Database is accessible on localhost:1521
    pause
    exit /b 1
)

echo ✅ Application user created successfully

REM Create database schema
echo 🗄️ Creating database schema...
sqlplus nmit_portal/nmit_portal_password@localhost:1521/FREE @src\main\resources\db\schema.sql

if %errorlevel% neq 0 (
    echo ❌ Failed to create database schema
    pause
    exit /b 1
)

echo ✅ Database schema created successfully

REM Insert sample data
echo 📊 Inserting sample data...
sqlplus nmit_portal/nmit_portal_password@localhost:1521/FREE @src\main\resources\db\sample-data.sql

if %errorlevel% neq 0 (
    echo ❌ Failed to insert sample data
    pause
    exit /b 1
)

echo ✅ Sample data inserted successfully

REM Build the application
echo 🔨 Building the application...
mvn clean compile

if %errorlevel% neq 0 (
    echo ❌ Failed to build application
    pause
    exit /b 1
)

echo ✅ Application built successfully

echo.
echo 🎉 Setup completed successfully!
echo.
echo 📋 Next Steps:
echo 1. Start the application: mvn spring-boot:run
echo 2. Access Swagger UI: http://localhost:8080/api/swagger-ui.html
echo 3. Test login with: admin / admin123
echo.
echo 🔧 Configuration:
echo - Database URL: jdbc:oracle:thin:@localhost:1521/FREE
echo - Application User: nmit_portal
echo - Server Port: 8080
echo.

pause