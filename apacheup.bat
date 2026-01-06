@echo off
setlocal enabledelayedexpansion

:: ============================
:: CONFIGURATION
:: ============================

:: Change this to your Apache service name as shown by:  sc query
:: Common names: "Apache2.4", "Apache24", "Apache2.2"
set "APACHE_SERVICE_NAME=Apache2.4"

:: How many seconds between checks
set "CHECK_INTERVAL_SEC=30"

:: Log file path
set "LOG_FILE=%~dp0apache_uptimer.log"

:: Optional: test a URL instead of only service state
:: If you don't want HTTP checking, leave APACHE_URL empty ("")
set "APACHE_URL=http://127.0.0.1/"

:: ============================
:: INTERNAL STATE
:: ============================

set "START_TIME=%time%"
set "START_DATE=%date%"
set /a TOTAL_UPTIME_SEC=0

echo ==================================================>> "%LOG_FILE%"
echo UPTIMER START: %DATE% %TIME% >> "%LOG_FILE%"
echo Monitoring service: %APACHE_SERVICE_NAME% >> "%LOG_FILE%"
echo Check interval: %CHECK_INTERVAL_SEC% seconds >> "%LOG_FILE%"
if defined APACHE_URL echo HTTP check URL: %APACHE_URL% >> "%LOG_FILE%"
echo ==================================================>> "%LOG_FILE%"
echo.

:: ============================
:: MAIN LOOP
:: ============================
:LOOP

:: --- Check service state ---
for /f "tokens=3 delims= " %%S in ('sc query "%APACHE_SERVICE_NAME%" ^| find "STATE"') do (
    set "SERVICE_STATE=%%S"
)

if /i "!SERVICE_STATE!"=="RUNNING" (
    set "STATUS=RUNNING"
) else (
    set "STATUS=STOPPED"
)

:: --- Optional HTTP check if service is RUNNING ---
set "HTTP_OK="
if /i "%STATUS%"=="RUNNING" if defined APACHE_URL (
    :: Use PowerShell to quickly hit the URL (without output)
    powershell -Command ^
        "try {Invoke-WebRequest -Uri '%APACHE_URL%' -UseBasicParsing -TimeoutSec 5 ^> $null; exit 0} catch {exit 1}"
    if %errorlevel%==0 (
        set "HTTP_OK=YES"
    ) else (
        set "HTTP_OK=NO"
    )
)

:: --- If service stopped or HTTP fails, try restart ---
if /i "%STATUS%"=="STOPPED" (
    echo [%DATE% %TIME%] Apache service STOPPED. Attempting restart...>> "%LOG_FILE%"
    net start "%APACHE_SERVICE_NAME%" >> "%LOG_FILE%" 2>&1
    timeout /t 5 /nobreak >nul

    :: Recheck state
    for /f "tokens=3 delims= " %%S in ('sc query "%APACHE_SERVICE_NAME%" ^| find "STATE"') do (
        set "SERVICE_STATE=%%S"
    )
    if /i "!SERVICE_STATE!"=="RUNNING" (
        echo [%DATE% %TIME%] Restart SUCCESS.>> "%LOG_FILE%"
    ) else (
        echo [%DATE% %TIME%] Restart FAILED. Service still not running.>> "%LOG_FILE%"
    )
) else (
    if defined APACHE_URL (
        if /i "%HTTP_OK%"=="YES" (
            echo [%DATE% %TIME%] OK - service RUNNING, HTTP OK >> "%LOG_FILE%"
        ) else if /i "%HTTP_OK%"=="NO" (
            echo [%DATE% %TIME%] WARN - service RUNNING, HTTP FAILED.>> "%LOG_FILE%"
        ) else (
            echo [%DATE% %TIME%] OK - service RUNNING (no HTTP check) >> "%LOG_FILE%"
        )
    ) else (
        echo [%DATE% %TIME%] OK - service RUNNING >> "%LOG_FILE%"
    )

    :: Add uptime for this interval
    set /a TOTAL_UPTIME_SEC+=CHECK_INTERVAL_SEC
)

:: --- Periodic uptime summary ---
:: Every 20 loops, log cumulative uptime
if not defined LOOP_COUNT set /a LOOP_COUNT=0
set /a LOOP_COUNT+=1
if !LOOP_COUNT! GEQ 20 (
    call :LOG_UPTIME
    set /a LOOP_COUNT=0
)

:: --- Wait and loop again ---
timeout /t %CHECK_INTERVAL_SEC% /nobreak >nul
goto :LOOP

:: ============================
:: UPTIME LOGGING SUBROUTINE
:: ============================
:LOG_UPTIME
set /a HOURS=TOTAL_UPTIME_SEC/3600
set /a REMAINDER=TOTAL_UPTIME_SEC%%3600
set /a MINUTES=REMAINDER/60
set /a SECONDS=REMAINDER%%60

echo [%DATE% %TIME%] Cumulative UPTIME: !HOURS!h !MINUTES!m !SECONDS!s >> "%LOG_FILE%"
goto :eof
