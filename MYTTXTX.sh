#!/usr/bin/env bash
# text2pdf.sh - Simple Text to PDF converter for Linux Mint
# Dependencies: enscript, ps2pdf (from ghostscript)

set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 input.txt [output.pdf]"
    exit 1
fi

INPUT="$1"

if [ ! -f "$INPUT" ]; then
    echo "Error: '$INPUT' not found."
    exit 1
fi

BASENAME="$(basename "$INPUT" .txt)"

if [ $# -ge 2 ]; then
    OUTPUT="$2"
else
    OUTPUT="${BASENAME}.pdf"
fi

TMP_PS="$(mktemp /tmp/text2pdfXXXXXX.ps)"

# Convert text to PostScript
enscript -B -p "$TMP_PS" "$INPUT"

# Convert PostScript to PDF
ps2pdf "$TMP_PS" "$OUTPUT"

rm -f "$TMP_PS"

echo "Created: $OUTPUT"
