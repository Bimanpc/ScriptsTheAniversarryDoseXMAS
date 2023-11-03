@echo off
set /p snooze_time="Enter snooze time in seconds: "
ping 127.0.0.1 -n %snooze_time% > nul
