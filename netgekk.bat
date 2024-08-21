@echo off
netsh interface set interface "Local Area Connection" admin=disable
timeout /t 5
netsh interface set interface "Local Area Connection" admin=enable
echo Network interface reset.
pause
