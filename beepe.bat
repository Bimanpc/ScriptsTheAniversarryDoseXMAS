@echo off
mshta vbscript:Execute("CreateObject(""SAPI.SpVoice"").Speak(""Testing speakers"")(window.close)")
