@echo off
setlocal ENABLEDELAYEDEXPANSION

:: ==========================================
:: SSD TRIMMER APP - single .BAT launcher
:: Requires: Windows 8+ and PowerShell
:: ==========================================

:: ---- Settings ----
set "LOG_DIR=%~dp0logs"
set "LOG_FILE=%LOG_DIR%\ssd_trimmer_%DATE:/=-%_%TIME::=-%.log"

if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%" >nul 2>&1
)

echo ========================================== >> "%LOG_FILE%"
echo SSD TRIMMER APP STARTED: %DATE% %TIME% >> "%LOG_FILE%"
echo ========================================== >> "%LOG_FILE%"

echo.
echo [SSD TRIMMER] Detecting SSD volumes and running TRIM...
echo See log: "%LOG_FILE%"
echo.

:: ---- Call PowerShell to handle detection + TRIM ----
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass ^
  -Command ^
  "try {
      Write-Output '=== SSD TRIMMER RUN: {0} ===' -f (Get-Date)  | Tee-Object -FilePath '%LOG_FILE%' -Append | Out-Null

      # Get all physical disks that are SSD
      \$ssdDisks = Get-PhysicalDisk -ErrorAction Stop | Where-Object { \$_.MediaType -eq 'SSD' }

      if (-not \$ssdDisks -or \$ssdDisks.Count -eq 0) {
          'No SSD disks detected. Exiting.' | Tee-Object -FilePath '%LOG_FILE%' -Append
          exit 0
      }

      'Detected SSDs:' | Tee-Object -FilePath '%LOG_FILE%' -Append
      \$ssdDisks | Select-Object FriendlyName, SerialNumber, MediaType | Format-Table | Out-String | Tee-Object -FilePath '%LOG_FILE%' -Append | Out-Null

      # Map SSD physical disks -> volumes
      \$ssdDiskNumbers = \$ssdDisks | ForEach-Object { \$_.DeviceId }

      \$ssdVolumes = Get-Volume -ErrorAction SilentlyContinue | Where-Object {
          \$_.DriveLetter -ne \$null -and \$_.DriveType -eq 'Fixed'
      }

      # We don't have a perfect mapping solely with Get-Volume here; to stay robust,
      # we just TRIM all fixed volumes (safe on SSDs; HDDs ignore TRIM).
      'Optimizing all fixed volumes (SSD-safe):' | Tee-Object -FilePath '%LOG_FILE%' -Append

      foreach (\$vol in \$ssdVolumes) {
          \$letter = \$vol.DriveLetter
          if (-not \$letter) { continue }

          \$msg = 'Running TRIM on volume {0}:' -f (\$letter + ':')
          \$msg | Tee-Object -FilePath '%LOG_FILE%' -Append

          try {
              Optimize-Volume -DriveLetter \$letter -ReTrim -Verbose -ErrorAction Stop |
                Tee-Object -FilePath '%LOG_FILE%' -Append
          }
          catch {
              ('  FAILED on {0}: {1}' -f \$letter, \$_.Exception.Message) |
                  Tee-Object -FilePath '%LOG_FILE%' -Append
          }
      }

      '=== SSD TRIMMER COMPLETED ===' | Tee-Object -FilePath '%LOG_FILE%' -Append
  }
  catch {
      'FATAL ERROR: ' + \$_.Exception.Message | Tee-Object -FilePath '%LOG_FILE%' -Append
      exit 1
  }"

set "ERR=%ERRORLEVEL%"

echo.
if "%ERR%"=="0" (
    echo [SSD TRIMMER] Completed. Check log for details.
) else (
    echo [SSD TRIMMER] Completed with errors (code %ERR%). See log file.
)

echo.
pause
endlocal
exit /b %ERR%
