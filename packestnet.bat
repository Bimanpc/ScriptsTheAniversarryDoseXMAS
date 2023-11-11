@echo off
echo Starting packet capture......

REM Set the capture file name and path
set captureFile=C:\Path\To\Your\Capture\file.pcap

REM Set the interface to capture packets on (use "tshark -D" to list available interfaces)
set interface=1

REM Set the capture filter if needed (optional)
set captureFilter=udp port 80

REM Start packet capture using TShark
tshark -i %interface% -f "%captureFilter%" -w "%captureFile%"

echo Packet capture complete. Press any key to exit.
pause >nul
