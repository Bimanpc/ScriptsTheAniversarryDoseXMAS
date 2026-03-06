@echo off
REM ============================================
REM Simple Timer Application for Windows Batch
REM ============================================
setlocal enabledelayedexpansion

cls
echo.
echo ====================================
echo       TIMER APPLICATION v1.0
echo ====================================
echo.

REM Get input from user
set /p minutes="Enter minutes (0-59): "
set /p seconds="Enter seconds (0-59): "

REM Validate input
if "%minutes%"=="" set minutes=0
if "%seconds%"=="" set seconds=0

REM Convert to total seconds
set /a totalseconds=minutes*60+seconds

if %totalseconds% leq 0 (
    echo Invalid time entered!
    timeout /t 2
    goto :eof
)

cls
echo.
echo ====================================
echo     TIMER STARTED
echo ====================================
echo.

REM Timer loop
:timer_loop
set /a minutes=totalseconds/60
set /a seconds=totalseconds%%60

REM Format display with leading zeros
if %minutes% lss 10 (set displaymin=0%minutes%) else (set displaymin=%minutes%)
if %seconds% lss 10 (set displaysec=0%seconds%) else (set displaysec=%seconds%)

cls
echo.
echo ====================================
echo     TIME REMAINING: %displaymin%:%displaysec%
echo ====================================
echo.
echo Press Ctrl+C to stop the timer
echo.

REM Decrease time
set /a totalseconds=totalseconds-1

REM Wait 1 second
timeout /t 1 /nobreak

REM Check if time is up
if %totalseconds% gtr 0 goto timer_loop

REM Time is up
cls
echo.
echo ====================================
echo     TIMER FINISHED!
echo ====================================
echo.
echo Time's up! ^G ^G ^G
echo.
timeout /t 3
