@echo off
setlocal enabledelayedexpansion

REM Get current date and time
for /f "tokens=1-3 delims=:" %%a in ('time /t') do (
    set "hour=%%a"
)

echo Current Hour: !hour!

endlocal
