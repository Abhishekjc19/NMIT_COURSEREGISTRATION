@echo off
echo ========================================
echo  Starting NMIT Portal Backend Server
echo ========================================
echo.
cd /d "%~dp0"
echo Current directory: %CD%
echo.

REM Check if Java is available
java -version
if errorlevel 1 (
    echo ERROR: Java is not installed or not in PATH
    pause
    exit /b 1
)

echo.
echo Starting Spring Boot application...
echo Backend will be available at: http://localhost:8080
echo.
echo Press Ctrl+C to stop the server
echo.

REM Run using the compiled classes
java -cp "target/classes;%USERPROFILE%/.m2/repository/*" com.nmit.portal.NmitPortalApplication

pause
