@echo off
REM Ρύθμισε την ώρα αφύπνισης (24ωρη μορφή)
set WAKE_TIME=05:30

schtasks /create ^
 /tn "WakeUpTimer" ^
 /tr "cmd.exe /c exit" ^
 /sc once ^
 /st %WAKE_TIME% ^
 /ru SYSTEM ^
 /rl HIGHEST ^
 /f ^
 /wake

echo Wake-up timer ορίστηκε για %WAKE_TIME%
pause
