REM @echo off 
powercfg/batteryreport
start "" edge "%~dp0battery-Report.html"
TIMEOUT 1
del battery-report.html
