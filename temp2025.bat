@echo off
echo Cleaning up temporary files...

:: Delete temp files for the current user
rd /s /q %temp%

:: Delete temp files from the Windows temp folder
rd /s /q C:\Windows\Temp

:: Recreate the %temp% directory after deletion
mkdir %temp%
mkdir C:\Windows\Temp

echo Temp cleanup completed.
pause
