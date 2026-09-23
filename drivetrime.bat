@echo off
title Windows 11 SSD Optimizer
color 0B

echo =========================================
echo      Windows 11 SSD Optimizer
echo =========================================
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Run as Administrator.
    pause
    exit
)

echo.
echo Current TRIM Status:
fsutil behavior query DisableDeleteNotify

echo.
echo Enabling TRIM if disabled...
fsutil behavior set DisableDeleteNotify 0 >nul

echo.
echo Running SSD ReTrim...
powershell -Command "Get-PhysicalDisk | Where-Object MediaType -eq 'SSD'"

powershell -Command "Get-Volume | Where-Object {$_.DriveType -eq 'Fixed'} | Optimize-Volume -ReTrim -Verbose"

echo.
echo SSD Optimization Complete!
echo.
pause
