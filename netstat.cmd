@echo off
echo Checking network connection...
ping google.com
if %errorlevel% equ 0 (
    echo Network is reachable.
) else (
    echo Network is unreachable.
)
