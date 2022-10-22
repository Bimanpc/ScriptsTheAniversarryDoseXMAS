@echo off
echo  'Trace route for the given site'
@echo off
title trace the root to the host
Set /p host_name= enter hostname or ip for which you want to trace the route:
if defined host_name (
powershell -Command tracert -d %Host% >>tracert_result.txt
)