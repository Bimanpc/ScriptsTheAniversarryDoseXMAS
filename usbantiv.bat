@echo off
echo Removing virus from USB drive..............................
attrib -h -s -r -a /s /d <DriveLetter>:*.*
echo Virus removal complete.
pause
