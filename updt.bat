@echo off
REM DNS4EU UPDATER - Batch Script
REM This script updates DNS settings for DNS4EU service

setlocal enabledelayedexpansion

REM Define DNS4EU servers
set DNS4EU_PRIMARY=185.253.5.0
set DNS4EU_SECONDARY=185.253.6.0

REM Get the network adapter name (modify as needed)
set ADAPTER=Ethernet

echo Updating DNS settings to DNS4EU...
echo Primary DNS: %DNS4EU_PRIMARY%
echo Secondary DNS: %DNS4EU_SECONDARY%

REM Update DNS settings (requires admin privileges)
netsh interface ipv4 set dns name="%ADAPTER%" static %DNS4EU_PRIMARY% primary
netsh interface ipv4 add dns name="%ADAPTER%" %DNS4EU_SECONDARY% index=2

echo DNS settings updated successfully!
pause
