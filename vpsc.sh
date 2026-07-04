#!/bin/bash

# Cloudflare Tunnel Setup for Ubuntu
# Requires: sudo privileges, Cloudflare account, and domain

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Cloudflare Tunnel Setup ===${NC}"

# 1. Check if running as root/sudo
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: This script requires sudo/root privileges.${NC}"
   exit 1
fi

# 2. Update system packages
echo -e "${YELLOW}[1/6] Updating package lists...${NC}"
apt-get update -y

# 3. Install required dependencies
echo -e "${YELLOW}[2/6] Installing dependencies...${NC}"
apt-get install -y curl wget gnupg apt-transport-https ca-certificates

# 4. Add Cloudflare repository and install cloudflared
echo -e "${YELLOW}[3/6] Adding Cloudflare repository...${NC}"
mkdir -p /etc/apt/keyrings
curl --location https://pkg.cloudflare.com/cloudflare-main.gpg | \
    tee /etc/apt/keyrings/cloudflare-main.asc >/dev/null

echo "deb [signed-by=/etc/apt/keyrings/cloudflare-main.asc] https://pkg.cloudflare.com/cloudflared jammy main" | \
    tee /etc/apt/sources.list.d/cloudflared.list

apt-get update -y
apt-get install -y cloudflared

# 5. Verify installation
echo -e "${YELLOW}[4/6] Verifying installation...${NC}"
cloudflared version || { echo -e "${RED}Cloudflared installation failed!${NC}"; exit 1; }

# 6. Create systemd service configuration
echo -e "${YELLOW}[5/6] Creating systemd service...${NC}"

read -p "Enter your Cloudflare Tunnel name (default: my-tunnel): " TUNNEL_NAME
TUNNEL_NAME=${TUNNEL_NAME:-my-tunnel}

read -p "Enter the localhost service URL (e.g., http://localhost:8080): " SERVICE_URL
SERVICE_URL=${SERVICE_URL:-http://localhost:8080}

cat > /etc/systemd/system/cloudflared-${TUNNEL_NAME}.service << EOF
[Unit]
Description=Cloudflare Tunnel ${TUNNEL_NAME}
After=network.target

[Service]
Type=simple
User=root
Restart=always
ExecStart=/usr/local/bin/cloudflared tunnel --no-autoupdate run --token YOUR_TOKEN_HERE
ExecStop=/bin/kill -TERM \$MAINPID
TimeoutStopSec=30

[Install]
WantedBy=multi-user.target
EOF

echo -e "${GREEN}Service created at: /etc/systemd/system/cloudflared-${TUNNEL_NAME}.service${NC}"

# 7. Authentication instructions
echo -e "${YELLOW}[6/6] Final Steps:${NC}"
echo ""
echo -e "${GREEN}To complete setup:${NC}"
echo ""
echo "1. Authenticate cloudflared:"
echo "   sudo -u $(whoami) cloudflared login"
echo ""
echo "2. Create a tunnel:"
echo "   sudo cloudflared tunnel create ${TUNNEL_NAME}"
echo ""
echo "3. Configure YAML file (automatic generation example):"
echo "   sudo mkdir -p ~/.cloudflared"
echo "   sudo cloudflared tunnel config write ${TUNNEL_NAME}"
echo ""
echo "4. Edit configuration:"
echo "   sudo nano /root/.cloudflared/${TUNNEL_NAME}.yml"
echo ""
echo "   Example config to add under 'tunnel': '${TUNNEL_NAME}' UUID,"
echo "   and define ingress rules like:"
echo "      - hostname: subdomain.your-domain.com"
echo "        service: ${SERVICE_URL}"
echo "      - service: http_status:404"
echo ""
echo "5. Get token and paste into systemd service:"
echo "   sudo cloudflared tunnel --url ${SERVICE_URL} login"
echo ""
echo "6. Enable and start the service:"
echo "   systemctl daemon-reload"
echo "   systemctl enable cloudflared-${TUNNEL_NAME}"
echo "   systemctl start cloudflared-${TUNNEL_NAME}"
echo ""
echo "7. Monitor logs:"
echo "   journalctl -u cloudflared-${TUNNEL_NAME} -f"
echo ""
echo -e "${GREEN}Setup completed! Follow the authentication steps above.${NC}"

# Optional: Auto-authenticate if preferred method selected
read -p "Do you want to authenticate now? (y/n) " auth_now
if [[ $auth_now =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Starting authentication...${NC}"
    sudo -u "$USER" cloudflared login --accept-source-ip-header
fi
