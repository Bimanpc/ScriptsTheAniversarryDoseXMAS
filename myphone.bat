@echo off
REM Check if ADB is installed
where adb >nul 2>nul
if %errorlevel% neq 0 (
    echo ADB not found. Please install it and add it to your PATH.
    pause
    exit /b
)

REM Start ADB server
adb start-server

REM List connected devices
echo Listing connected devices:
adb devices

REM Wait for device to be connected (Optional)
echo Waiting for device to be connected...
adb wait-for-device

REM Get device information
echo Getting device information:
adb shell getprop ro.product.model
adb shell getprop ro.build.version.release

REM Take a screenshot
echo Taking a screenshot...
adb exec-out screencap -p > %userprofile%\Desktop\android_screenshot.png

REM Pull a file from the device to the PC
REM Change /sdcard/filename.txt to the actual file path on your device
REM Change %userprofile%\Desktop\filename.txt to the desired location on your PC
echo Pulling a file from the device...
adb pull /sdcard/filename.txt %userprofile%\Desktop\filename.txt

REM Push a file from the PC to the device
REM Change %userprofile%\Desktop\filename.txt to the actual file path on your PC
REM Change /sdcard/filename.txt to the desired location on your device
echo Pushing a file to the device...
adb push %userprofile%\Desktop\filename.txt /sdcard/filename.txt

REM Reboot the device
echo Rebooting the device...
adb reboot

echo All tasks completed.
pause
