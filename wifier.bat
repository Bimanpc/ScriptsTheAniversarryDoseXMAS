@echo off
:loop
cls
echo.
echo Checking WiFi signal strength...
echo.
netsh wlan show interfaces | findstr /C:"Signal"
timeout /t 5
goto loop
