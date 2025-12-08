@echo off
title Network Latency Stop Script
echo ============================================
echo   NETWORK LATENCY STOP / RESET TOOL
echo ============================================

:: Step 1 - Flush DNS cache
echo Flushing DNS cache...
ipconfig /flushdns

:: Step 2 - Reset TCP/IP stack
echo Resetting TCP/IP stack...
netsh int ip reset

:: Step 3 - Reset Winsock catalog
echo Resetting Winsock catalog...
netsh winsock reset

:: Step 4 - Stop common background services that may cause latency
echo Stopping Background Intelligent Transfer Service (BITS)...
net stop bits

echo Stopping Windows Update service...
net stop wuauserv

:: Step 5 - Quick latency test (ping Google DNS)
echo Testing latency to 8.8.8.8...
ping 8.8.8.8 -n 4

echo ============================================
echo   Network reset complete. Please reboot PC
echo ============================================
pause
