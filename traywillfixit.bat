@echo off
echo Cleaning up system tray icons...
echo.

:: Check if Explorer is running
tasklist | findstr /I "explorer.exe" >nul
if %errorlevel% == 0 (
    echo Stopping Explorer...
    taskkill /f /im explorer.exe >nul 2>&1
) else (
    echo Explorer not running.
)

:: Wait a moment to ensure Explorer has stopped
timeout /t 2 >nul

:: Restart Explorer
echo Restarting Explorer...
start explorer.exe

echo.
echo Tray cleanup complete.
pause
exit
