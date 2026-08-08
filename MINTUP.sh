#!/bin/bash
# ============================================================
#  Linux Mint Core System Maintenance & Diagnostic Script
#  Usage: sudo ./core_smd.sh
# ============================================================

set -e  # Exit on error

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Must run as root ---
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}This script must be run as root (use sudo).${NC}"
    exit 1
fi

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  Linux Mint Core System Management${NC}"
echo -e "${CYAN}========================================${NC}"

# --- 1. Update & Upgrade ---
echo -e "\n${YELLOW}[1/7] Updating package lists...${NC}"
apt update

echo -e "\n${YELLOW}[2/7] Upgrading installed packages...${NC}"
apt upgrade -y

echo -e "\n${YELLOW}[3/7] Removing unnecessary packages...${NC}"
apt autoremove -y && apt autoclean -y

# --- 2. Flatpak Updates ---
echo -e "\n${YELLOW}[4/7] Updating Flatpak applications...${NC}"
if command -v flatpak &>/dev/null; then
    flatpak update -y
    flatpak uninstall --unused -y
else
    echo -e "${YELLOW}Flatpak not installed. Skipping.${NC}"
fi

# --- 3. System Cleanup ---
echo -e "\n${YELLOW}[5/7] Cleaning temporary files & caches...${NC}"
rm -rf /tmp/* 2>/dev/null || true
rm -rf /var/tmp/* 2>/dev/null || true
journalctl --vacuum-time=7d 2>/dev/null || true

# --- 4. Disk Usage Report ---
echo -e "\n${YELLOW}[6/7] Disk usage overview:${NC}"
df -h / /home 2>/dev/null || df -h /

# --- 5. System Health Check ---
echo -e "\n${YELLOW}[7/7] System health snapshot:${NC}"

echo -e "\n${GREEN}-- Uptime --${NC}"
uptime

echo -e "\n${GREEN}-- Memory --${NC}"
free -h

echo -e "\n${GREEN}-- Top 5 CPU consumers --${NC}"
ps aux --sort=-%cpu | head -n 6

echo -e "\n${GREEN}-- Top 5 Memory consumers --${NC}"
ps aux --sort=-%mem | head -n 6

echo -e "\n${GREEN}-- Failed Services --${NC}"
systemctl --failed --no-pager || true

echo -e "\n${GREEN}-- Last 5 kernel logs --${NC}"
journalctl -k --no-pager -n 5 || true

echo -e "\n${CYAN}========================================${NC}"
echo -e "${GREEN}  Core maintenance complete!${NC}"
echo -e "${CYAN}========================================${NC}"

# --- Optional: Reboot check ---
if [[ -f /var/run/reboot-required ]]; then
    echo -e "\n${RED}⚠ A reboot is required to complete updates.${NC}"
    read -p "Reboot now? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        reboot
    fi
fi
