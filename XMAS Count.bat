@echo off
setlocal enabledelayedexpansion

set "target=12/25/2023"
set "format=yyyy/MM/dd"
set "now=%date:~10,4%/%date:~4,2%/%date:~7,2%"

for /f "delims=" %%a in ('wmic os get localdatetime ^| find "."') do set datetime=%%a

set "year=!datetime:~0,4!"
set "month=!datetime:~4,2!"
set "day=!datetime:~6,2!"

set "today=!year!/!month!/!day!"

for /f %%a in ('powershell -command "& {((get-date '%target%') - (get-date '%today%')).Days}"') do set countdown=%%a

echo Christmas Countdown: %countdown% days remaining!
pause
