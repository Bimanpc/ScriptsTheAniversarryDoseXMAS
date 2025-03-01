@echo off
REM Change directory to where the Starlink monitoring tool is located
cd C:\Path\To\Starlink\Tool

REM Run the Starlink monitoring tool
start starlink-monitor.exe

REM Wait for the tool to finish (if needed)
REM timeout /t 60

REM Optional: Log the output to a file
REM starlink-monitor.exe > output.log

echo Starlink monitoring tool has been executed.
pause
