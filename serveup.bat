@echo off
:loop
echo Checking Google server status...
ping -n 1 google.com
if %errorlevel% == 0 (
    echo Google server is up.
) else (
    echo Google server is down.
)
timeout /t 60
goto loop
