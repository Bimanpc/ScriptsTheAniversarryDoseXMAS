#!/usr/bin/env bash
# Simple FTP client for Linux Mint
# Usage:
#   ./ftp_client.sh
# Then follow the prompts.

set -e

read -rp "FTP server (host or IP): " FTP_HOST
read -rp "FTP port [21]: " FTP_PORT
FTP_PORT=${FTP_PORT:-21}

read -rp "Username: " FTP_USER
read -srp "Password: " FTP_PASS
echo

echo "Connecting to $FTP_HOST:$FTP_PORT as $FTP_USER ..."

# Create a temporary script for the ftp session
TMP_CMD=$(mktemp)

cat > "$TMP_CMD" <<EOF
user $FTP_USER $FTP_PASS
prompt
binary
# Uncomment next line if you want to start in a specific directory:
# cd /path/on/server

# Examples:
#   ls                - list files
#   get file.txt      - download file.txt
#   put local.txt     - upload local.txt
#   mget *.zip        - download multiple files
#   mput *.txt        - upload multiple files
#   delete file.txt   - delete remote file
#   mkdir newdir      - create directory
#   rmdir olddir      - remove directory
#   pwd               - show current remote directory
#   bye               - exit

# Drop to interactive mode:
EOF

# Run ftp in interactive mode, starting with our commands
ftp -inv "$FTP_HOST" "$FTP_PORT" < "$TMP_CMD"

rm -f "$TMP_CMD"
