@echo off
:: Confirm the drive to be purged
set /p drive=Enter the drive letter to purge (e.g., D:): 

:: Warning message and confirmation prompt
echo WARNING: This will delete all files and directories on drive %drive%.
set /p confirm=Are you sure you want to continue? (Y/N): 
if /I not "%confirm%"=="Y" (
    echo Operation cancelled.
    goto :EOF
)

:: Start the purge
echo Purging drive %drive%...

:: Disable echo to avoid printing each command
@echo off

:: Remove all files and directories
rmdir /S /Q %drive%\* 2>nul
if exist %drive%\* (
    echo Failed to purge some files or directories.
) else (
    echo Drive %drive% purged successfully.
)

:: Re-enable echo
@echo on

:: End of script
:EOF
