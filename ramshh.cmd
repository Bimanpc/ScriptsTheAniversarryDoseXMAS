@echo off
echo Clearing RAM...
%windir%\system32\rundll32.exe advapi32.dll,ProcessIdleTasks
echo RAM cleared.
pause
