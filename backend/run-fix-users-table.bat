@echo off
REM Fix USERS table by adding missing columns
echo ========================================
echo FIXING USERS TABLE SCHEMA
echo ========================================
echo.
echo Connecting to Oracle Database...
echo.

sqlplus -S nmit_portal/nmit_portal_password@localhost:1521/FREE @"%~dp0QUICK-FIX-USERS.sql"

echo.
echo ========================================
echo DONE! Check output above for any errors
echo ========================================
echo.
pause
