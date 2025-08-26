@echo off
rem Adjust the path to TOTALCMD64.EXE if needed
set "TC=C:\Program Files\totalcmd\TOTALCMD64.EXE"

start "" "%TC%" /O /L="C:\Work" /R="D:\Backup"
