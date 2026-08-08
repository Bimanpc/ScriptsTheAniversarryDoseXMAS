#!/bin/bash
# ============================================
# curl_demo.sh — A curl utility script
# Compatible with Linux Mint / Ubuntu-based systems
# ============================================

set -euo pipefail  # Exit on error, undefined vars, and pipe failures

# ---- Configuration ----
OUTPUT_DIR="${HOME}/Downloads/curl_output"
LOG_FILE="${OUTPUT_DIR}/curl_log.txt"
TIMEOUT=30

# ---- Functions ----

create_dirs() {
    mkdir -p "$OUTPUT_DIR"
}

# Download a single file
download_file() {
    local url="$1"
    local filename="$2"
    echo "[INFO] Downloading: $url"
    curl -L --fail --connect-timeout "$TIMEOUT" \
         -o "${OUTPUT_DIR}/${filename}" \
         "$url" 2>/dev/null && \
        echo "[OK] Saved to ${OUTPUT_DIR}/${filename}" || \
        echo "[ERROR] Failed to download $url"
}

# Fetch and display HTTP headers
show_headers() {
    local url="$1"
    echo "[INFO] Headers for: $url"
    echo "-----------------------------------"
    curl -sIL "$url" | grep -iE '^(HTTP|Content-Type|Content-Length|Server|Last-Modified)'
    echo "-----------------------------------"
}

# Check website status code
check_status() {
    local url="$1"
    local code
    code=$(curl -sIL -o /dev/null -w '%{http_code}' --connect-timeout "$TIMEOUT" "$url")
    echo "[STATUS] $url → HTTP $code"
}

# POST JSON data to an API
post_json() {
    local url="$1"
    local json_data="$2"
    echo "[INFO] POSTing JSON to: $url"
    curl -s -X POST "$url" \
         -H 'Content-Type: application/json' \
         -d "$json_data" | jq '.' 2>/dev/null || \
        echo "[WARN] Install 'jq' for pretty JSON output: sudo apt install jq"
}

# Download with progress bar (great for large files)
download_large() {
    local url="$1"
    local filename="$2"
    echo "[INFO] Downloading with progress: $filename"
    curl -L --progress-bar \
         -o "${OUTPUT_DIR}/${filename}" \
         "$url"
}

# Resume a partial download
resume_download() {
    local url="$1"
    local filename="$2"
    echo "[INFO] Resuming download: $filename"
    curl -L -C - \
         -o "${OUTPUT_DIR}/${filename}" \
         "$url"
}

# ---- Main ----

main() {
    create_dirs

    echo "===== curl Utility Script ====="
    echo ""

    # Example 1: Check a website's status
    check_status "https://www.google.com"

    # Example 2: Show HTTP headers
    show_headers "https://www.google.com"

    # Example 3: Download a file
    download_file \
        "https://raw.githubusercontent.com/git/git/master/README.md" \
        "git_readme.md"

    # Example 4: Download with progress bar
    download_large \
        "https://github.com/git/git/archive/refs/heads/master.tar.gz" \
        "git-source.tar.gz"

    # Example 5: POST JSON (uncomment and customize)
    # post_json "https://httpbin.org/post" '{"key":"value","name":"test"}'

    # Example 6: Resume interrupted download
    # resume_download "https://example.com/largefile.zip" "largefile.zip"

    echo ""
    echo "[DONE] All operations complete. Output in: $OUTPUT_DIR"
}

main "$@"
