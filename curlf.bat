@echo off
set URL=http://localhost:8080/status

:loop
echo Checking server...
curl -s %URL%
echo.
timeout /t 5 >nul
goto loop
