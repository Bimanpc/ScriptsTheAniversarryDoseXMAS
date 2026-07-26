#!/bin/bash

# =============================================================================
# LLM CURL Application for Ubuntu
# A command-line tool to interact with various LLM APIs using CURL
# =============================================================================

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${HOME}/.config/llm-curl/config"
API_KEY=""
BASE_URL=""
MODEL="gpt-4o-mini"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# -----------------------------------------------------------------------------
# Setup Function
# -----------------------------------------------------------------------------
setup() {
    echo -e "${GREEN}=== LLM CURL App Setup ===${NC}"
    
    # Create config directory
    mkdir -p "${HOME}/.config/llm-curl"
    
    # Choose provider
    echo "Select API Provider:"
    echo "1. OpenAI"
    echo "2. Anthropic (Claude)"
    echo "3. Ollama (Local)"
    echo "4. Google Gemini"
    echo "5. Custom Endpoint"
    read -p "Enter choice [1-5]: " choice
    
    case $choice in
        1)
            BASE_URL="https://api.openai.com/v1/chat/completions"
            MODEL="gpt-4o-mini"
            ;;
        2)
            BASE_URL="https://api.anthropic.com/v1/messages"
            MODEL="claude-3-haiku-20240307"
            ;;
        3)
            BASE_URL="http://localhost:11434/api/generate"
            MODEL="llama3.2"
            ;;
        4)
            BASE_URL="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
            MODEL="gemini-1.5-flash"
            ;;
        5)
            read -p "Enter custom BASE_URL: " BASE_URL
            read -p "Enter MODEL name: " MODEL
            ;;
        *)
            echo -e "${RED}Invalid choice.${NC}"
            return 1
            ;;
    esac
    
    # Get API key
    if [ "$choice" != "3" ]; then  # Ollama doesn't need API key
        read -sp "Enter API Key: " API_KEY
        echo
    else
        API_KEY=""
    fi
    
    # Save configuration
    cat > "${CONFIG_FILE}" << EOF
BASE_URL="${BASE_URL}"
MODEL="${MODEL}"
API_KEY="${API_KEY}"
EOF
    
    chmod 600 "${CONFIG_FILE}"
    echo -e "${GREEN}Configuration saved successfully!${NC}"
}

# -----------------------------------------------------------------------------
# Load Configuration
# -----------------------------------------------------------------------------
load_config() {
    if [ ! -f "${CONFIG_FILE}" ]; then
        echo -e "${RED}No configuration found. Run 'setup' first.${NC}"
        exit 1
    fi
    
    source "${CONFIG_FILE}"
}

# -----------------------------------------------------------------------------
# Interactive Chat Mode
# -----------------------------------------------------------------------------
chat() {
    load_config
    
    echo -e "${GREEN}=== Interactive Chat (${MODEL}) ===${NC}"
    echo "Type your messages (empty line to send, 'exit' to quit)"
    
    CONVERSATION=""
    
    while true; do
        read -r -p "> " USER_INPUT
        
        if [ "$USER_INPUT" == "exit" ]; then
            break
        fi
        
        if [ -z "$USER_INPUT" ]; then
            continue
        fi
        
        # Add user message to conversation
        if [ -z "$CONVERSATION" ]; then
            CONVERSATION="{\"role\": \"user\", \"content\": \"$USER_INPUT\"}"
        else
            CONVERSATION="${CONVERSATION}, {\"role\": \"user\", \"content\": \"$USER_INPUT\"}"
        fi
        
        # Prepare payload
        PAYLOAD="{
            \"model\": \"${MODEL}\",
            \"messages\": [${CONVERSATION}]
        }"
        
        # Make API call
        echo -e "${YELLOW}Processing...${NC}"
        
        if [ -n "$API_KEY" ]; then
            RESPONSE=$(curl -s -X POST "${BASE_URL}" \
                -H "Content-Type: application/json" \
                -H "Authorization: Bearer ${API_KEY}" \
                -d "${PAYLOAD}")
        else
            # For Ollama/local models
            RESPONSE=$(curl -s -X POST "${BASE_URL}" \
                -H "Content-Type: application/json" \
                -d "{\"model\": \"${MODEL}\", \"prompt\": \"${USER_INPUT}\", \"stream\": false}")
        fi
        
        # Extract AI response
        AI_RESPONSE=$(echo "$RESPONSE" | jq -r '.choices[0].message.content // .content // ""')
        
        if [ -n "$AI_RESPONSE" ]; then
            echo -e "\n${GREEN}AI:${NC} ${AI_RESPONSE}"
            
            # Add AI response to conversation
            CONVERSATION="${CONVERSATION}, {\"role\": \"assistant\", \"content\": \"$(echo "$AI_RESPONSE" | sed 's/"/\\"/g')\"}"
        else
            echo -e "${RED}Error: $(echo "$RESPONSE" | jq -r '.error.message // "Unknown error"' 2>/dev/null)${NC}"
        fi
        
        echo ""
    done
}

# -----------------------------------------------------------------------------
# Single Query Mode
# -----------------------------------------------------------------------------
query() {
    local PROMPT="$1"
    
    if [ -z "$PROMPT" ]; then
        echo -e "${RED}Please provide a prompt.${NC}"
        usage
    fi
    
    load_config
    
    if [ -n "$API_KEY" ]; then
        RESPONSE=$(curl -s -X POST "${BASE_URL}" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${API_KEY}" \
            -d "{
                \"model\": \"${MODEL}\",
                \"messages\": [{\"role\": \"user\", \"content\": \"$PROMPT\"}]
            }")
    else
        RESPONSE=$(curl -s -X POST "${BASE_URL}" \
            -H "Content-Type: application/json" \
            -d "{\"model\": \"${MODEL}\", \"prompt\": \"$PROMPT\", \"stream\": false}")
    fi
    
    echo "$RESPONSE" | jq -r '.choices[0].message.content // .content // .response // ""'
}

# -----------------------------------------------------------------------------
# Usage Information
# -----------------------------------------------------------------------------
usage() {
    echo -e "${GREEN}LLM CURL App - Command Line Reference${NC}"
    echo ""
    echo "Usage:"
    echo "  ./llm-curl-app.sh setup         - Configure API settings"
    echo "  ./llm-curl-app.sh chat          - Interactive chat session"
    echo "  ./llm-curl-app.sh query \"text\"  - Single query mode"
    echo "  ./llm-curl-app.sh file FILEPATH - Read from file and query"
    echo ""
    echo "Environment Variables (optional):"
    echo "  OPENAI_API_KEY       - For OpenAI compatibility"
    echo "  ANTHROPIC_API_KEY    - For Claude compatibility"
    echo ""
    echo "Examples:"
    echo "  ./llm-curl-app.sh setup"
    echo "  ./llm-curl-app.sh chat"
    echo "  ./llm-curl-app.sh query \"What is quantum computing?\""
    echo "  ./llm-curl-app.sh file prompt.txt"
}

# -----------------------------------------------------------------------------
# File Query Mode
# -----------------------------------------------------------------------------
file_query() {
    local FILE="$1"
    
    if [ ! -f "$FILE" ]; then
        echo -e "${RED}File not found: ${FILE}${NC}"
        exit 1
    fi
    
    QUERY_TEXT=$(cat "$FILE")
    query "$QUERY_TEXT"
}

# -----------------------------------------------------------------------------
# Main Entry Point
# -----------------------------------------------------------------------------
main() {
    case "${1:-}" in
        setup)
            setup
            ;;
        chat)
            chat
            ;;
        query)
            query "$2"
            ;;
        file)
            file_query "$2"
            ;;
        usage|--help|-h)
            usage
            ;;
        *)
            usage
            exit 1
            ;;
    esac
}

# Run main if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
