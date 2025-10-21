' ListBluetoothDevices.vbs
' Runs PowerShell to list paired Bluetooth devices

Set objShell = CreateObject("WScript.Shell")
psCmd = "powershell -command ""Get-PnpDevice -Class Bluetooth"""
objShell.Run psCmd, 1, True
