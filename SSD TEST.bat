@echo off
echo ===================================
echo SSD Health Check 2.0
echo ===================================
echo.
wmic diskdrive get status,model,mediaType
echo.
pause
