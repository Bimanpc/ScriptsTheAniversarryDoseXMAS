@echo off
echo Network Management Script
echo ------------------------

REM Display network configuration
echo Displaying network configuration...
ipconfig /all
echo.

REM Ping a server (e.g., Google's DNS server)
set SERVER=8.8.8.8
echo Pinging server %SERVER%...
ping %SERVER%
echo.

REM Check network connectivity
echo Checking network connectivity...
if %errorlevel% == 0 (
    echo Network is active.
) else (
    echo Network is down.
)
echo.

REM Display active network connections
echo Displaying active network connections...
netstat -ano
echo.

REM Flush DNS cache
echo Flushing DNS cache...
ipconfig /flushdns
echo.

echo Network management tasks completed.
pause
