@echo off
REM Enable OpenSSH Server feature (Windows 10/11)
dism /Online /Add-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0

REM Set sshd service to start automatically
sc config sshd start= auto

REM Start sshd service
net start sshd

REM (Optional) Allow SSH in Windows Firewall
netsh advfirewall firewall add rule name="OpenSSH-Server-In-TCP" dir=in action=allow protocol=TCP localport=22

echo.
echo OpenSSH Server should now be installed and running on port 22.
pause
