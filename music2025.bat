@echo off
setlocal

REM Set the path to your music file
set musicFile="C:\path\to\your\music\file.mp3"

REM Check if the file exists
if not exist %musicFile% (
    echo The music file does not exist.
    pause
    exit /b
)

REM Play the music file
start "" %musicFile%

REM Wait for the music to finish playing
timeout /t 300 /nobreak >nul

REM Clean up
endlocal
