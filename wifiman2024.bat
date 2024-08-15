@echo off
echo Wi-Fi Manager
echo 1. Connect to Wi-Fi
echo 2. Disconnect from Wi-Fi
echo 3. Show Wi-Fi status
echo 4. Exit
set /p choice=Enter your choice: 

if %choice%==1 goto connect
if %choice%==2 goto disconnect
if %choice%==3 goto status
if %choice%==4 goto exit

:connect
set /p ssid=Enter SSID: 
set /p password=Enter Password: 
netsh wlan connect name=%ssid%
goto end

:disconnect
netsh wlan disconnect
goto end

:status
netsh wlan show interfaces
goto end

:exit
exit

:end
pause
