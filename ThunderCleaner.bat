@echo off
echo Cleaning Standby Memory...
echo Before:
echo Available Memory:
wmic os get FreePhysicalMemory /Value
echo Cleaning...
start "" /min "EmptyStandbyList.exe" standbylist
timeout /t 5 /nobreak >nul
echo After:
echo Available Memory:
wmic os get FreePhysicalMemory /Value
echo Cleaning Completed.
pause
