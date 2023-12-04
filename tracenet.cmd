@echo off
set /p target=Enter target IP or hostname: 
echo Tracing route to %target%...
tracert %target%
