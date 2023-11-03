@echo off
:clock
cls
echo Current Time:
time /t
timeout /t 1 /nobreak > NUL
goto clock
