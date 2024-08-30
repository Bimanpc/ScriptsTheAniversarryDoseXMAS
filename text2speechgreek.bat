@echo off
set text="Γειά σου κόσμε"
PowerShell -Command "Add-Type -AssemblyName System.Speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.SelectVoice('Microsoft Stefanos'); $speak.Speak('%text%');"
pause
