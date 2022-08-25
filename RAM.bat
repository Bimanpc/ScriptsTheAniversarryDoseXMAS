ECHO ============================

ECHO HARDWARE INFO

ECHO ============================

systeminfo | findstr /c:"Total Memory RAM"

wmic cpu get name

wmic diskdrive get name,model,size

wmic path win32_videocontroller get name

wmic path win32_VideoController get CurrentHorizontalResolution,CurrentVerticalResolution