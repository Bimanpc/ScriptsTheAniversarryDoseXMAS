@echo off
:: Run a quick scan using Windows Defender

echo Starting Windows Defender Quick Scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1

echo Scan completed.
pause
