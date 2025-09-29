@echo off
title 🚨 SOS BUTTON 🚨
color 0C

:MENU
cls
echo ============================================
echo              🚨 SOS BUTTON 🚨
echo ============================================
echo.
echo  Press [S] to trigger SOS
echo  Press [Q] to quit
echo.
choice /c SQ /n /m "Your choice: "

if errorlevel 2 goto QUIT
if errorlevel 1 goto SOS

:SOS
echo.
echo *** SOS TRIGGERED at %date% %time% *** >> sos_log.txt
echo Sending alert...
:: Play a system beep
echo ^G
:: Popup alert
msg * "🚨 SOS ALERT! 🚨"
:: Optional: emergency contact form
:: start https://civilprotection.gov.gr/112
pause
goto MENU

:QUIT
echo Exiting SOS app...
timeout /t 2 >nul
exit
