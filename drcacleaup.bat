@echo off
title Driver Cache Cleanup
echo ==============================
echo     Driver Cache Cleanup
echo ==============================

echo.
echo Running as Administrator...
echo Please wait while we clear the driver cache.

:: Request administrator privileges
if "%1"=="" (
    echo Requesting administrative privileges...
    powershell start -verb runas '%0' admin
    exit /b
)

:: Set folders to clean
set cache_dirs=%windir%\System32\DriverStore\FileRepository %windir%\inf\

:: Loop through folders to remove files
for %%d in (%cache_dirs%) do (
    echo Cleaning folder: %%d
    del /s /q "%%d\*.inf"
    del /s /q "%%d\*.pnf"
)

echo.
echo Cleanup complete!
pause
exit
