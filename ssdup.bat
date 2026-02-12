@echo off
title SSD Information Tool
color 0A

echo ============================================
echo        SSD / Storage Info Script
echo ============================================
echo.

echo [*] Detecting physical drives...
wmic diskdrive get Model,SerialNumber,InterfaceType,MediaType,Size
echo.

echo [*] Listing partitions...
wmic partition get Name,Type,Size
echo.

echo [*] Volume information...
wmic logicaldisk get Name,FileSystem,Size,FreeSpace,VolumeName
echo.

echo [*] SMART status (basic)...
wmic diskdrive get Status,Model
echo.

echo [*] Detailed SMART attributes (PowerShell)...
powershell -command "Get-PhysicalDisk | Format-Table FriendlyName, MediaType, Size, HealthStatus, OperationalStatus"
echo.

echo [*] NVMe info (if available)...
powershell -command "Get-PhysicalDisk | Where-Object {$_.BusType -eq 'NVMe'} | Format-List *"
echo.

echo ============================================
echo        Script Completed
echo ============================================
pause
