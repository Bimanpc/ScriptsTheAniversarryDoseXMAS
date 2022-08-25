@echo off
for /F "tokens=1-4 usebackq delims=. " %%1 in (`date /t`) do set mydate=%%4.%%3.%%2
ren работа.txt работа%mydate%.txt