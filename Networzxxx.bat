@echo off
echo Network Speed Optimization Script

:: Flush DNS cache
ipconfig /flushdns

:: Release and renew IP address
ipconfig /release
ipconfig /renew

:: Reset Winsock
netsh winsock reset

:: Disable Windows Update Delivery Optimization
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DOPriority /t REG_DWORD /d 5 /f

:: Disable Nagle's Algorithm
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v TcpAckFrequency /t REG_DWORD /d 1 /f

:: Disable Large Send Offload (LSO)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DisableTaskOffload /t REG_DWORD /d 1 /f

:: Enable Receive Window Auto-Tuning
netsh interface tcp set global autotuning=normal

:: Disable Windows Scaling Heuristics
netsh interface tcp set heuristics disabled

echo Network optimization completed.
