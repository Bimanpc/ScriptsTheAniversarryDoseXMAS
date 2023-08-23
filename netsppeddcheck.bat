@echo off
title Network Speed Test

:: Change directory to where speedtest-cli is located
cd "C:\path\to\speedtest-cli"

:: Run the speed test
echo Running network speed test...
speedtest-cli

:: Pause to see the results
pause
