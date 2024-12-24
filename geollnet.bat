@echo off
REM Script to get network geolocation information

echo Fetching geolocation information...
curl http://ipinfo.io > geolocation_info.txt

REM Parsing the JSON response (optional, for more advanced users)
for /f "tokens=1,2 delims=:" %%A in ('findstr /R "^\(ip\|city\|region\|country\|loc\|org\|postal\)" geolocation_info.txt') do (
    set %%A=%%B
)
echo IP Address: %ip%
echo City: %city%
echo Region: %region%
echo Country: %country%
echo Location: %loc%
echo Organization: %org%
echo Postal Code: %postal%

echo Geolocation information has been saved to geolocation_info.txt
pause
