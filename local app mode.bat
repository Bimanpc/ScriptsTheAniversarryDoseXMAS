@echo off

color 0A

echo Open the  link in distraction free 

SET /p input=Enter the url: 

SET "stringAppParam=^-^-app^="
SET "finalParam=%stringAppParam%%input%"

REM Off course have to set the path

START "" chrome %finalParam% --no-referrers