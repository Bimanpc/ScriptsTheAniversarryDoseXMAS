@echo off
echo Set objShell = CreateObject("WScript.Shell") > msgbox.vbs
echo objShell.Popup "Γεια σας! Αυτό είναι ένα μήνυμα σε Ελληνική Νοηματική Γλώσσα.", 5, "Μήνυμα", 64 >> msgbox.vbs
wscript msgbox.vbs
del msgbox.vbs
