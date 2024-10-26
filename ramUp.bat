@echo off
setlocal

echo RAM Status Checker
echo ====================

REM Get total physical memory (in MB)
for /F "tokens=2 delims==" %%G in ('wmic computersystem get TotalPhysicalMemory /value') do set TotalMemory=%%G
set /A TotalMemoryMB=%TotalMemory:~0,-6%

REM Get available memory (in MB)
for /F "tokens=2 delims==" %%G in ('wmic os get FreePhysicalMemory /value') do set FreeMemory=%%G
set /A FreeMemoryMB=%FreeMemory% / 1024

REM Calculate used memory (in MB)
set /A UsedMemoryMB=%TotalMemoryMB% - %FreeMemoryMB%

REM Calculate percentage used
set /A PercentUsed=(%UsedMemoryMB% * 100) / %TotalMemoryMB%

echo Total Memory: %TotalMemoryMB% MB
echo Available Memory: %FreeMemoryMB% MB
echo Used Memory: %UsedMemoryMB% MB
echo Percentage Used: %PercentUsed%%%

pause
endlocal
