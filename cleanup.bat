@echo off
title Internet Cache Cleanup

echo ========================================
echo   Internet Cache Cleanup Application
echo ========================================
echo.

REM Deleting Internet Explorer Cache
echo Clearing Internet Explorer Cache...
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
echo Internet Explorer cache cleared.
echo.

REM Deleting Google Chrome Cache
echo Clearing Google Chrome Cache...
set ChromeCachePath=%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache
if exist "%ChromeCachePath%" (
    rmdir /s /q "%ChromeCachePath%"
    echo Google Chrome cache cleared.
) else (
    echo Google Chrome cache directory not found.
)
echo.

REM Deleting Firefox Cache
echo Clearing Firefox Cache...
set FirefoxCachePath=%APPDATA%\Mozilla\Firefox\Profiles
for /d %%d in ("%FirefoxCachePath%\*.default*") do (
    if exist "%%d\cache2" (
        rmdir /s /q "%%d\cache2"
        echo Firefox cache cleared for profile %%d.
    )
)
echo.

echo Cache cleanup complete.
pause
exit
