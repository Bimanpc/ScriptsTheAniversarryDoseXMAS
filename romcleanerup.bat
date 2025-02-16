@echo off
cd /d "%~dp0"
echo Cleaning up ROM folder...

:: Delete unnecessary files (add more extensions as needed)
echo Deleting unwanted file types...
del /s /q "*.txt" "*.nfo" "*.jpg" "*.png" "*.gif" "*.sfv" "*.doc" "*.dat"

:: Remove duplicate ROMs (files with (1), (2), etc.)
echo Removing duplicate ROMs...
for /r %%f in (*(*).*) do (
    echo Deleting duplicate: "%%f"
    del "%%f"
)

:: Optional: Rename files to remove spaces and special characters
:: Uncomment the following block to enable renaming
:: echo Renaming ROM files...
:: for /r %%f in (*.*) do (
::     set "newname=%%~nf"
::     set "newname=%newname: =_%"
::     ren "%%f" "%newname%%%~xf"
:: )

echo Cleanup complete!
pause
