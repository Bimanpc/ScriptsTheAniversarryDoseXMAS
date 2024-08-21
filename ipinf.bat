@echo off
setlocal enabledelayedexpansion

:: Replace with your API key
set API_KEY=your_api_key_here

:: Input file containing IP addresses (one per line)
set INPUT_FILE=ips.txt

:: Output file for geolocation results
set OUTPUT_FILE=geolocation_results.txt

:: Clear the output file
echo. > %OUTPUT_FILE%

:: Loop through each IP address in the input file
for /f "tokens=*" %%A in (%INPUT_FILE%) do (
    set IP=%%A
    echo Processing IP: !IP!
    curl -s "https://ipinfo.io/!IP!?token=%API_KEY%" >> %OUTPUT_FILE%
    echo. >> %OUTPUT_FILE%
)

echo Geolocation lookup completed.
pause
