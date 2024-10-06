@echo off
:: Video Cache Cleanup Script

echo Cleaning up video cache files...
echo.

:: Set cache paths (you can add or modify paths as needed)
set CACHE_DIRS=(
    "%LocalAppData%\Microsoft\MediaPlayer\Cache"
    "%LocalAppData%\Temp"
    "%LocalAppData%\Google\Chrome\User Data\Default\Cache"
    "%LocalAppData%\Mozilla\Firefox\Profiles\*.default-release\cache2"
)

:: Loop through cache directories and clean them up
for %%D in %CACHE_DIRS% do (
    if exist "%%~D" (
        echo Deleting cache in: %%~D
        rd /s /q "%%~D"
        mkdir "%%~D"
    ) else (
        echo Directory not found: %%~D
    )
)

echo.
echo Video cache cleanup complete.
pause
