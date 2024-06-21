@echo off
setlocal enabledelayedexpansion

rem Input text to be converted to speech
set "text=Η πόλη της Αθήνας  έχει ένα αρκετά εκτεταμένο κέντρο, στο οποίο συγκεντρώνονται τα περισσότερα καταστήματα, δημόσιες υπηρεσίες, αξιοθέατα και χώροι αναψυχής."

rem Making the temp file
set num=%random%
if exist temp%num%.vbs goto num
echo ' > "temp%num%.vbs"
echo set speech = Wscript.CreateObject("SAPI.spVoice") >> "temp%num%.vbs"
echo speech.speak "%text%" >> "temp%num%.vbs"
start temp%num%.vbs
pause
del temp%num%.vbs
goto :eof
