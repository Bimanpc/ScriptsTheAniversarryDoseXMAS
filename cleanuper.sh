#!/bin/bash
# UBUNTU TERMINAL PURGE SCRIPT
# Safe local cleanup – no network calls

echo "[*] Starting purge..."

# Clear terminal scrollback
echo "[*] Clearing terminal buffer..."
printf "\033c"

# Clean APT cache
echo "[*] Cleaning APT cache..."
sudo apt-get clean
sudo apt-get autoclean

# Remove orphaned packages
echo "[*] Removing unused packages..."
sudo apt-get autoremove -y

# Clear system logs (safe truncation)
echo "[*] Truncating system logs..."
sudo find /var/log -type f -exec truncate -s 0 {} \;

# Clear user cache
echo "[*] Clearing user cache..."
rm -rf ~/.cache/*

# Clear temporary files
echo "[*] Clearing /tmp..."
sudo rm -rf /tmp/*

echo "[✓] Purge complete."
