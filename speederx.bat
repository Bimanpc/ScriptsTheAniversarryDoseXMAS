@echo off
echo ============================================
echo   Wi-Fi Speedup Utility (Admin Safe)
echo ============================================

:: Flush DNS cache
echo Flushing DNS cache...
ipconfig /flushdns

:: Release current IP
echo Releasing IP address...
ipconfig /release

:: Renew IP
echo Renewing IP address...
ipconfig /renew

:: Reset Winsock catalog
echo Resetting Winsock...
netsh winsock reset

:: Reset TCP/IP stack
echo Resetting TCP/IP...
netsh int ip reset

:: Disable/Enable wireless adapter (optional)
:: Replace "Wi-Fi" with your adapter name
echo Restarting Wi-Fi adapter...
netsh interface set interface "Wi-Fi" admin=disable
timeout /t 5 >nul
netsh interface set interface "Wi-Fi" admin=enable

echo ============================================
echo   Done! Please reboot for full effect.
echo ============================================
pause
