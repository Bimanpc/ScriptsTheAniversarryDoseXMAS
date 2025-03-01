@echo off
echo Cleaning up RAM...
echo.

:: Close unnecessary processes
taskkill /F /IM chrome.exe
taskkill /F /IM notepad.exe
taskkill /F /IM explorer.exe
echo.

:: Start explorer again
start explorer.exe

echo RAM cleanup done.
pause
