@echo off
setlocal enabledelayedexpansion

:: Check if ADB is available
where adb >nul 2>&1
if errorlevel 1 (
    echo [ERROR] ADB not found in PATH.
    echo Install platform-tools or add adb.exe to PATH.
    exit /b 1
)

:: Check for connected device
for /f "tokens=1" %%A in ('adb devices ^| findstr /R "device$"') do (
    set DEVICE=%%A
)

if not defined DEVICE (
    echo [ERROR] No Android device detected.
    exit /b 1
)

echo Device detected: %DEVICE%

:: Query Android version
for /f "tokens=2 delims==" %%A in ('adb shell getprop ro.build.version.release') do (
    set ANDROID_VERSION=%%A
)

:: Query SDK level
for /f "tokens=2 delims==" %%A in ('adb shell getprop ro.build.version.sdk') do (
    set SDK_LEVEL=%%A
)

echo -----------------------------
echo Android Version: %ANDROID_VERSION%
echo SDK Level:       %SDK_LEVEL%
echo -----------------------------

endlocal
pause
