@echo off
echo Flushing the system tray...
taskkill /f /IM explorer.exe
start explorer.exe
echo System tray has been flushed.
pause
