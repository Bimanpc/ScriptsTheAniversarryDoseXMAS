@echo off
echo Hardware Test Script

REM Test CPU
echo Testing CPU...
wmic cpu get name, caption
echo.

REM Test Memory (RAM)
echo Testing Memory (RAM)...
wmic memorychip get capacity
echo.

REM Test Hard Drive
echo Testing Hard Drive...
wmic diskdrive get model, size
echo.

REM Test Network Connection
echo Testing Network Connection...
ipconfig
echo.

REM Test Graphics Card (Adapter)
echo Testing Graphics Card (Adapter)...
wmic path win32_videocontroller get caption
echo.

REM Test Sound Card (Audio Device)
echo Testing Sound Card (Audio Device)...
wmic sounddev get caption
echo.

REM End of Hardware Test

pause
