@echo off
echo Starting NMIT Portal Frontend...
echo.
cd /d "%~dp0"
echo Current directory: %CD%
echo.
echo Installing/verifying dependencies...
call npm install
echo.
echo Starting Vite development server...
echo Frontend will be available at: http://localhost:5173
echo.
call npm run dev
pause
