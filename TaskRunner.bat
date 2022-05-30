ECHO OFF
tasklist /fi “ImageName eq Zoom.exe” /fo csv 2>NUL | find /I “Zoom.exe”>NUL
if “%ERRORLEVEL%”==”0”  (echo Process / Application runns ) else (echo Process / Application isn't running)
PAUSE