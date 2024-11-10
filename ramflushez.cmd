@echo off
echo Clearing RAM Cache...
ipconfig /flushdns
rundll32.exe advapi32.dll,ProcessIdleTasks
echo RAM Cache Cleared
pause
