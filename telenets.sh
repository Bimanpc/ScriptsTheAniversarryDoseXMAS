#!/usr/bin/env bash
# putty-like.sh - minimal PuTTY-style SSH/Telnet launcher in pure bash

CONFIG_FILE="${HOME}/.putty_like_profiles"

# -----------------------------
# Helpers
# -----------------------------

load_profiles() {
    [[ -f "$CONFIG_FILE" ]] || return
    mapfile -t PROFILES < <(grep -v '^[[:space:]]*$' "$CONFIG_FILE")
}

save_profile() {
    local name="$1" host="$2" port="$3" proto="$4" user="$5"
    mkdir -p "$(dirname "$CONFIG_FILE")"
    {
        echo "# name|host|port|proto|user"
        [[ -f "$CONFIG_FILE" ]] && grep -v "^${name}|" "$CONFIG_FILE" | grep -v '^#'
        echo "${name}|${host}|${port}|${proto}|${user}"
    } > "${CONFIG_FILE}.tmp"
    mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
}

print_profiles() {
    local i=0
    for p in "${PROFILES[@]}"; do
        name="${p%%|*}"
        echo "[$i] $name"
        ((i++))
    done
}

select_profile() {
    local idx
    echo
    print_profiles
    echo
    read -rp "Select profile index: " idx
    [[ "$idx" =~ ^[0-9]+$ ]] || { echo "Invalid index"; return 1; }
    [[ $idx -ge 0 && $idx -lt ${#PROFILES[@]} ]] || { echo "Out of range"; return 1; }
    SELECTED="${PROFILES[$idx]}"
    return 0
}

launch_profile() {
    IFS='|' read -r name host port proto user <<< "$SELECTED"
    [[ -z "$host" ]] && { echo "Invalid profile"; return 1; }

    case "$proto" in
        ssh|"")
            [[ -z "$user" ]] && target="$host" || target="${user}@${host}"
            echo "Launching SSH: $target:$port"
            if [[ -n "$port" ]]; then
                exec ssh -p "$port" "$target"
            else
                exec ssh "$target"
            fi
            ;;
        telnet)
            echo "Launching Telnet: $host:$port"
            if command -v telnet >/dev/null 2>&1; then
                if [[ -n "$port" ]]; then
                    exec telnet "$host" "$port"
                else
                    exec telnet "$host"
                fi
            else
                echo "telnet command not found."
            fi
            ;;
        *)
            echo "Unsupported protocol: $proto"
            ;;
    esac
}

create_profile() {
    echo "=== Create / Update Profile ==="
    read -rp "Profile name: " name
    read -rp "Host: " host
    read -rp "Port (blank for default): " port
    read -rp "Protocol [ssh/telnet] (default ssh): " proto
    proto="${proto:-ssh}"
    read -rp "Username (blank for current user): " user

    save_profile "$name" "$host" "$port" "$proto" "$user"
    echo "Profile '$name' saved."
}

delete_profile() {
    echo
    print_profiles
    echo
    read -rp "Index to delete: " idx
    [[ "$idx" =~ ^[0-9]+$ ]] || { echo "Invalid index"; return 1; }
    [[ $idx -ge 0 && $idx -lt ${#PROFILES[@]} ]] || { echo "Out of range"; return 1; }

    local i=0
    mkdir -p "$(dirname "$CONFIG_FILE")"
    {
        echo "# name|host|port|proto|user"
        for p in "${PROFILES[@]}"; do
            [[ $i -eq $idx ]] && { ((i++)); continue; }
            echo "$p"
            ((i++))
        done
    } > "${CONFIG_FILE}.tmp"
    mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    echo "Profile deleted."
}

main_menu() {
    while true; do
        echo
        echo "==============================="
        echo "   PuTTY-like SSH Launcher"
        echo "==============================="
        echo "Config: $CONFIG_FILE"
        echo
        echo "1) List profiles"
        echo "2) Launch profile"
        echo "3) Create / update profile"
        echo "4) Delete profile"
        echo "5) Quit"
        echo
        read -rp "Choice: " choice

        load_profiles

        case "$choice" in
            1)
                if [[ ${#PROFILES[@]} -eq 0 ]]; then
                    echo "No profiles yet."
                else
                    print_profiles
                fi
                ;;
            2)
                if [[ ${#PROFILES[@]} -eq 0 ]]; then
                    echo "No profiles to launch."
                else
                    if select_profile; then
                        launch_profile
                    fi
                fi
                ;;
            3)
                create_profile
                ;;
            4)
                if [[ ${#PROFILES[@]} -eq 0 ]]; then
                    echo "No profiles to delete."
                else
                    delete_profile
                fi
                ;;
            5)
                echo "Bye."
                exit 0
                ;;
            *)
                echo "Invalid choice."
                ;;
        esac
    done
}

main_menu
