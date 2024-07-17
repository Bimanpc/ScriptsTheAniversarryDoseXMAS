@echo off
setlocal

REM Check if an argument was provided
if "%~1"=="" (
    echo Usage: %~nx0 "Your text here"
    exit /b 1
)

REM Combine all arguments into a single string
set "text=%~1"
shift
:loop
if "%~1"=="" goto continue
set "text=%text% %~1"
shift
goto loop

:continue

REM PowerShell script to speak the text
powershell -Command "Add-Type -TypeDefinition @'
using System;
using System.Speech.Synthesis;
public class Speech {
    public static void Speak(String text) {
        using (SpeechSynthesizer synth = new SpeechSynthesizer()) {
            synth.Speak(text);
        }
    }
}
'@; [Speech]::Speak('%text%');"

endlocal
exit /b 0
