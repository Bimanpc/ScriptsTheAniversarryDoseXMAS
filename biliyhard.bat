@echo off
echo Gathering hardware information...
echo ================================
echo.

:: Display the processor information
echo Processor Information:
wmic cpu get caption, deviceid, name, numberofcores, maxclockspeed, status
echo.

:: Display the memory information
echo Memory Information:
wmic memorychip get capacity, manufacturer, partnumber, speed
echo.

:: Display the disk drive information
echo Disk Drives:
wmic diskdrive get model, size, status
echo.

:: Display the video controller information
echo Video Controller:
wmic path win32_videocontroller get name, adapterram
echo.

:: Display the network adapter information
echo Network Adapters:
wmic nic where "netenabled='true'" get name, macaddress
echo.

:: System summary
echo ================================
echo System Summary:
systeminfo | findstr /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory" /C:"Available Physical Memory"
echo.

pause
