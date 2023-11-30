@echo off
set /p target=Enter target address: 
echo Checking open ports on %target%...
for /L %%i in (1, 1, 100) do (
    echo. | telnet %target% %%i | find "Open" >nul && echo Port %%i is open.
)
