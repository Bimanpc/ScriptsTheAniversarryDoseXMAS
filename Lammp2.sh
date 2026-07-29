#!/bin/bash
# ============================================================
#  Mint Web Stack — A XAMPP-like LAMP Manager for Linux Mint
#  Author: Lumo AI Assistant
#  Compatible with: Linux Mint 20/21/22 (based on Ubuntu)
# ============================================================

VERSION="1.0"
SCRIPT_NAME=$(basename "$0")

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Paths
WEB_ROOT="/var/www/html"
VHOST_DIR="/etc/apache2/sites-available"
MYSQL_CONF="/etc/mysql/mariadb.conf.d/50-server.cnf"
BACKUP_DIR="$HOME/mint-web-backups"

# Print helpers
print_info()    { echo -e "${BLUE}[INFO]${NC}  $1"; }
print_success() { echo -e "${GREEN}[OK]${NC}    $1"; }
print_warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# ── Banner ───────────────────────────────────────────────────
show_banner() {
    echo -e "${CYAN}"
    cat << 'BANNER'
  ╔═══════════════════════════════════════════╗
  ║         🐧  MINT WEB STACK  🐧             ║
  ║       A XAMPP-like LAMP Manager           ║
  ╚═══════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo -e "  Version: ${YELLOW}$VERSION${NC}"
    echo -e "  Web Root: ${YELLOW}$WEB_ROOT${NC}"
    echo -e "  PHP Version: ${YELLOW}$(php -v 2>/dev/null | head -1 | awk '{print $2}' || echo 'Not installed')${NC}"
    echo ""
}

# ── Check root ───────────────────────────────────────────────
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This action requires root privileges."
        echo "  Run: sudo $SCRIPT_NAME $1"
        exit 1
    fi
}

# ── Install packages ────────────────────────────────────────
install_stack() {
    check_root "install"
    show_banner

    print_info "Updating package list..."
    apt update -y

    print_info "Installing Apache2..."
    apt install -y apache2

    print_info "Installing MariaDB Server..."
    apt install -y mariadb-server

    print_info "Installing PHP + extensions..."
    apt install -y php libapache2-mod-php php-mysql php-cli php-curl php-gd \
                   php-json php-mbstring php-xml php-zip php-intl \
                   php-bcmath php-tokenizer php-fileinfo

    print_info "Installing phpMyAdmin..."
    DEBIAN_FRONTEND=noninteractive apt install -y phpmyadmin php-mbstring php-zip php-gd
    # Link phpMyAdmin into Apache
    if [ ! -f /etc/apache2/conf-available/phpmyadmin.conf ]; then
        ln -sf /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
    fi
    a2enconf phpmyadmin

    print_info "Enabling Apache modules..."
    a2enmod rewrite headers ssl

    print_info "Creating default info.php test page..."
    echo "<?php phpinfo(); ?>" > "$WEB_ROOT/info.php"

    print_info "Setting permissions on web root..."
    chown -R www-data:www-data "$WEB_ROOT"
    chmod -R 755 "$WEB_ROOT"

    print_info "Starting services..."
    systemctl enable apache2 mariadb
    systemctl restart apache2 mariadb

    # Secure MariaDB basics
    print_info "Securing MariaDB (basic)..."
    mysql -u root << 'SQL'
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost','127.0.0.1','::1');
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
SQL

    print_success "Installation complete!"
    echo ""
    echo -e "  ${GREEN}Localhost:${NC}      http://localhost/"
    echo -e "  ${GREEN}PHP Info:${NC}       http://localhost/info.php"
    echo -e "  ${GREEN}phpMyAdmin:${NC}     http://localhost/phpmyadmin/"
    echo -e "  ${GREEN}Web Root:${NC}       $WEB_ROOT"
    echo -e "  ${GREEN}DB User:${NC}        root (sudo mysql)"
    echo ""
    print_warn "For production, run: sudo mysql_secure_installation"
}

# ── Start services ──────────────────────────────────────────
start_services() {
    check_root "start"
    show_banner
    print_info "Starting Apache and MariaDB..."
    systemctl start apache2
    systemctl start mariadb

    sleep 1
    if systemctl is-active --quiet apache2; then
        print_success "Apache is running on port 80"
    else
        print_error "Apache failed to start"
    fi

    if systemctl is-active --quiet mariadb; then
        print_success "MariaDB is running on port 3306"
    else
        print_error "MariaDB failed to start"
    fi
}

# ── Stop services ───────────────────────────────────────────
stop_services() {
    check_root "stop"
    show_banner
    print_info "Stopping Apache and MariaDB..."
    systemctl stop apache2
    systemctl stop mariadb
    print_success "Services stopped."
}

# ── Restart services ────────────────────────────────────────
restart_services() {
    check_root "restart"
    show_banner
    print_info "Restarting Apache and MariaDB..."
    systemctl restart apache2
    systemctl restart mariadb
    print_success "Services restarted."
}

# ── Status ──────────────────────────────────────────────────
status_services() {
    show_banner
    echo -e "${CYAN}── Service Status ──${NC}"

    if systemctl is-active --quiet apache2; then
        print_success "Apache: Running (port 80)"
    else
        print_error "Apache: Stopped"
    fi

    if systemctl is-active --quiet mariadb; then
        print_success "MariaDB: Running (port 3306)"
    else
        print_error "MariaDB: Stopped"
    fi

    # Disk usage of web root
    if [ -d "$WEB_ROOT" ]; then
        SIZE=$(du -sh "$WEB_ROOT" 2>/dev/null | awk '{print $1}')
        print_info "Web root size: $SIZE"
    fi

    # Count sites
    SITE_COUNT=$(ls -1 "$VHOST_DIR"/*.conf 2>/dev/null | wc -l)
    print_info "Virtual hosts configured: $SITE_COUNT"

    # Quick port check
    if command -v ss &> /dev/null; then
        PORT80=$(ss -tlnp | grep ':80 ')
        PORT3306=$(ss -tlnp | grep ':3306 ')
        if [ -n "$PORT80" ]; then
            print_success "Port 80: Listening"
        else
            print_warn "Port 80: Not listening"
        fi
        if [ -n "$PORT3306" ]; then
            print_success "Port 3306: Listening"
        else
            print_warn "Port 3306: Not listening"
        fi
    fi

    echo ""
}

# ── Create virtual host ────────────────────────────────────
create_vhost() {
    check_root "vhost"
    show_banner

    read -rp "Enter project/site name (e.g., myapp): " SITENAME
    if [ -z "$SITENAME" ]; then
        print_error "Site name cannot be empty."
        exit 1
    fi

    DOMAIN="${SITENAME}.test"
    DOCROOT="/var/www/${SITENAME}"

    print_info "Creating virtual host: $DOMAIN"
    print_info "Document root: $DOCROOT"

    # Create docroot
    mkdir -p "$DOCROOT"
    cp "$WEB_ROOT/index.html" "$DOCROOT/index.html" 2>/dev/null || echo "<h1>Welcome to $DOMAIN</h1>" > "$DOCROOT/index.html"
    chown -R www-data:www-data "$DOCROOT"
    chmod -R 755 "$DOCROOT"

    # Apache vhost config
    cat << EOF > "$VHOST_DIR/${SITENAME}.conf"
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot $DOCROOT

    <Directory $DOCROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/${SITENAME}_error.log
    CustomLog \${APACHE_LOG_DIR}/${SITENAME}_access.log combined
</VirtualHost>
EOF

    a2ensite "${SITENAME}.conf"
    systemctl reload apache2

    # Add to /etc/hosts
    if ! grep -q "$DOMAIN" /etc/hosts; then
        echo "127.0.0.1   $DOMAIN www.$DOMAIN" >> /etc/hosts
        print_info "Added $DOMAIN to /etc/hosts"
    fi

    print_success "Virtual host created!"
    echo -e "  ${GREEN}URL:${NC}  http://$DOMAIN"
    echo -e "  ${GREEN}Path:${NC} $DOCROOT"
}

# ── Backup web root + DB ────────────────────────────────────
backup_all() {
    check_root "backup"
    show_banner

    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_PATH="$BACKUP_DIR/backup_$TIMESTAMP"
    mkdir -p "$BACKUP_PATH"

    # Backup web files
    print_info "Backing up web root ($WEB_ROOT)..."
    tar czf "$BACKUP_PATH/webroot.tar.gz" -C "$(dirname $WEB_ROOT)" "$(basename $WEB_ROOT)" 2>/dev/null
    print_success "Web files saved."

    # Backup databases
    print_info "Backing up all databases..."
    mysqldump -u root --all-databases --single-transaction > "$BACKUP_PATH/databases.sql" 2>/dev/null
    print_success "Database dump saved."

    # Backup Apache configs
    print_info "Backing up Apache configs..."
    tar czf "$BACKUP_PATH/apache_configs.tar.gz" -C /etc/apache2 sites-available 2>/dev/null
    print_success "Apache configs saved."

    echo ""
    print_success "Backup complete at: $BACKUP_PATH"
    TOTAL_SIZE=$(du -sh "$BACKUP_PATH" | awk '{print $1}')
    print_info "Total backup size: $TOTAL_SIZE"
}

# ── Uninstall everything ────────────────────────────────────
uninstall_stack() {
    check_root "uninstall"
    show_banner

    read -rp "Are you sure you want to uninstall everything? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        print_warn "Uninstall cancelled."
        exit 0
    fi

    print_info "Stopping services..."
    systemctl stop apache2 mariadb 2>/dev/null

    print_info "Removing packages..."
    apt purge -y apache2 mariadb-server php* phpmyadmin
    apt autoremove -y

    print_warn "Web root and databases were NOT removed. To delete manually:"
    echo "  sudo rm -rf /var/www/html /var/lib/mysql"
    print_success "Uninstallation complete."
}

# ── Help menu ───────────────────────────────────────────────
show_help() {
    show_banner
    cat << HELP
${CYAN}Usage:${NC} sudo ./$SCRIPT_NAME <command>

${GREEN}Commands:${NC}

  ${YELLOW}install${NC}     Install Apache, MariaDB, PHP, phpMyAdmin
  ${YELLOW}start${NC}       Start Apache and MariaDB
  ${YELLOW}stop${NC}        Stop Apache and MariaDB
  ${YELLOW}restart${NC}     Restart Apache and MariaDB
  ${YELLOW}status${NC}      Show status of all services
  ${YELLOW}vhost${NC}       Create a new virtual host (local dev site)
  ${YELLOW}backup${NC}      Backup web files + databases + configs
  ${YELLOW}uninstall${NC}   Remove all LAMP packages
  ${YELLOW}help${NC}        Show this help message

${GREEN}Quick Start:${NC}
  sudo ./$SCRIPT_NAME install
  sudo ./$SCRIPT_NAME status

${GREEN}After Install URLs:${NC}
  Web:        http://localhost/
  PHP Info:   http://localhost/info.php
  phpMyAdmin: http://localhost/phpmyadmin/

HELP
}

# ── Main ────────────────────────────────────────────────────
case "$1" in
    install)    install_stack ;;
    start)      start_services ;;
    stop)       stop_services ;;
    restart)    restart_services ;;
    status)     status_services ;;
    vhost)      create_vhost ;;
    backup)     backup_all ;;
    uninstall)  uninstall_stack ;;
    help|*)     show_help ;;
esac
