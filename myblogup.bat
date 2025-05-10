@echo off
set WEBSITE=https://pctechgreu.blogspot.com/
set LOG_FILE=uptime_log.txt

:loop
echo %date% %time% Checking %WEBSITE% >> %LOG_FILE%
ping -n 1 %WEBSITE% | find "TTL=" >> %LOG_FILE%
if %errorlevel% equ 0 (
    echo %date% %time% %WEBSITE% is UP >> %LOG_FILE%
) else (
    echo %date% %time% %WEBSITE% is DOWN >> %LOG_FILE%
)
timeout /t 60 /nobreak >nul
goto loop
