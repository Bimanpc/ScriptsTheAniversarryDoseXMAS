@echo off
:loop
cls
echo Battery Status:
wmic path Win32_Battery get EstimatedChargeRemaining, Status
timeout /t 5 /nobreak >nul
goto loop
