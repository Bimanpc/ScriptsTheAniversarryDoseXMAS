@echo off
setlocal enabledelayedexpansion

REM Prompt the user to enter the website
set /p website="Enter the website URL (without http:// or https://): "

REM Extract the IP address using nslookup
for /f "tokens=2" %%i in ('nslookup %website% ^| find "Address" ^| find /v "127.0.0.1"') do set ip=%%i

REM Check if IP was found
if "%ip%"=="" (
    echo Could not find IP address for %website%
    goto :eof
)

REM Use curl to get the location info from ipinfo.io
for /f "tokens=* delims=" %%i in ('curl -s http://ipinfo.io/%ip%') do set response=%%i

REM Extract the country from the response
for /f "tokens=2 delims=:," %%i in ('echo %response% ^| find "country"') do set country=%%i

REM Remove any double quotes from the country code
set country=%country:"=%

REM Check if the country was found
if "%country%"=="" (
    echo Could not determine the country for IP address %ip%
) else (
    echo The country for website %website% (IP: %ip%) is %country%
)

:end
pause
