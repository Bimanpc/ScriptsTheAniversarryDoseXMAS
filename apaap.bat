@echo off
:: Apache Uptime Checker
:: Save this as apache_uptime.bat

set SERVER=127.0.0.1
set PORT=80
set LOGFILE=apache_uptime.log

:CHECK
echo Checking Apache server at %SERVER%:%PORT% ...
echo [%date% %time%] Checking Apache server at %SERVER%:%PORT% >> %LOGFILE%

:: Use PowerShell to test TCP connection
powershell -command "if (Test-NetConnection %SERVER% -Port %PORT% -InformationLevel Quiet) { exit 0 } else { exit 1 }"

if %errorlevel%==0 (
    echo [%date% %time%] Apache is UP >> %LOGFILE%
    echo Apache is UP
) else (
    echo [%date% %time%] Apache is DOWN >> %LOGFILE%
    echo Apache is DOWN
)

:: Wait 60 seconds before next check
timeout /t 60 >nul
goto CHECK
