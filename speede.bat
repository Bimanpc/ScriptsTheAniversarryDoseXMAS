@echo off
echo Testing DNS response times...
echo --------------------------------

:: List of DNS servers
set DNS1=8.8.8.8   & REM Google DNS
set DNS2=1.1.1.1   & REM Cloudflare DNS
set DNS3=9.9.9.9   & REM Quad9 DNS
set DNS4=208.67.222.222 & REM OpenDNS

:: Ping each DNS server 4 times and display average response time
for %%D in (%DNS1% %DNS2% %DNS3% %DNS4%) do (
    echo Pinging DNS Server %%D...
    ping -n 4 %%D | findstr "Minimum ="
    echo --------------------------------
)

echo Test completed.
pause
