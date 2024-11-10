@echo off
echo Network Flusher Script
echo ----------------------
echo This script will clear your DNS cache, release and renew your IP address, and reset your network.

:: Run the commands as administrator
echo Checking for administrator rights...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrator privileges.
    pause
    exit /b
)

:: Flush DNS Cache
echo Flushing DNS cache...
ipconfig /flushdns

:: Release IP Address
echo Releasing IP address...
ipconfig /release

:: Renew IP Address
echo Renewing IP address...
ipconfig /renew

:: Reset Winsock
echo Resetting Winsock catalog...
netsh winsock reset

:: Reset IP stack
echo Resetting IP stack...
netsh int ip reset

:: Clear ARP Cache
echo Clearing ARP cache...
netsh interface ip delete arpcache

:: Notify completion
echo Network flush complete!
pause
