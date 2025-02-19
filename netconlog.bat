@echo off
:loop
netstat -an >> netconnectlog.txt
echo Logged at %date% %time% >> netconnectlog.txt
timeout /t 60 /nobreak >nul
goto loop
