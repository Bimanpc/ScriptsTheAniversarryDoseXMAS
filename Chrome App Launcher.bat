@echo off

color 0A

echo Open link in distraction free chrome

SET /p input=Enter url: 

SET "stringAppParam=^-^-app^="
SET "finalParam=%stringAppParam%%input%"

REM Of course have set the path of chrome first

START "" chrome %finalParam% --no-referrers