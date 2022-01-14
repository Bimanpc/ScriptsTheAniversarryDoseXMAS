@echo off
rem For each file in our folder
for %%a in (".\*") do (
rem check if the file has an extension and if it is not our script
if "%%~xa" NEQ "" if "%%~dpxa" NEQ "%~dpx0" (
rem check extension folder exists, if not is created
if not exist "%%~xa" mkdir "%%~xa"
rem Move file to directory
move "%%a" "%%~dpa%%~xa\"
))