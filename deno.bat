@echo off
REM Set the path to your Deno executable if it's not in your system PATH
SET DENO_PATH="C:\Path\To\Deno\deno.exe"

REM Navigate to the directory containing your Deno app
CD /D "C:\Path\To\Your\DenoApp"

REM Run the Deno application
%DENO_PATH% run --allow-net --allow-env main.ts

REM Pause to keep the command window open (optional)
PAUSE
