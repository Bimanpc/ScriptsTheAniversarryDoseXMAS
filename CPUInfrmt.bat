@echo off
echo CPU Information:
wmic cpu get caption, deviceid, name, numberofcores, maxclockspeed, status
pause
