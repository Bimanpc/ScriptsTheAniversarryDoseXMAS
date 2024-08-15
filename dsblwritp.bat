@echo off
echo Disabling write protection...
diskpart /s disable_write_protection.txt
pause
