@echo off
setlocal

rem Set the geolocation API URL
set "api_url=https://ipinfo.io/94.71.4.41"

rem Use curl to fetch the geolocation data
echo Retrieving geolocation information...
curl %api_url% -s > location.json

rem Display the results
echo Location data:
type location.json

rem Clean up
del location.json

pause
endlocal
