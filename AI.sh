#!/bin/bash

# Ubuntu AI LLM Agent Setup Script
# Creates a foundational AI agent environment with popular tools

set -e

echo "🚀 Starting Ubuntu AI Agent Setup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#######################################
# Configuration Variables
#######################################
AGENT_NAME="${AI_AGENT_NAME:-my_ai_agent}"
WORKSPACE_DIR="${HOME}/ai_agents/${AGENT_NAME}"
PYTHON_VERSION="3.10"
LLAMA_CPP_VER="latest"

#######################################
# Helper Functions
#######################################
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_warn "This script should ideally run as root for system packages."
        log_info "Proceeding with sudo where needed..."
    fi
}

prompt_confirm() {
    read -r -p "$1 [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

#######################################
# Main Installation Functions
#######################################

install_system_packages() {
    log_info "Updating system packages..."
    sudo apt update
    sudo apt install -y \
        build-essential \
        git \
        curl \
        wget \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
        libssl-dev \
        libffi-dev \
        libopenblas-dev \
        cmake \
        ninja-build \
        gcc g++ 
    
    log_info "System packages installed successfully"
}

setup_python_environment() {
    log_info "Setting up Python ${PYTHON_VERSION} virtual environment..."
    
    mkdir -p "$WORKSPACE_DIR"
    cd "$WORKSPACE_DIR"
    
    python3 -m venv venv
    source venv/bin/activate
    
    pip install --upgrade pip setuptools wheel
    
    log_info "Python environment ready at $WORKSPACE_DIR"
}

install_llm_dependencies() {
    log_info "Installing core AI dependencies..."
    
    source venv/bin/activate
    
    # Core libraries
    pip install \
        transformers>=4.35.0 \
        torch>=2.0.0 \
        accelerate>=0.24.0 \
        datasets>=2.14.0 \
        sentence-transformers>=2.2.0 \
        langchain>=0.0.350 \
        chromadb>=0.4.0
    
    # Alternative backend options (uncomment as needed)
    # pip install llama-cpp-python
    # pip install optimum[onnxruntime]
    
    log_info "Core AI dependencies installed"
}

create_basic_agent_structure() {
    log_info "Creating agent project structure..."
    
    cat > agent.py << 'EOF'
"""Basic AI Agent Framework for Ubuntu"""

import os
import sys
from pathlib import Path

class AIAgent:
    """Simple autonomous AI agent base class"""
    
    def __init__(self, model_path=None, max_tokens=2048):
        self.model_path = model_path
        self.max_tokens = max_tokens
        self.memory = []
        print(f"✅ Agent initialized: {self.__class__.__name__}")
    
    def load_model(self):
        """Load LLM from path or HuggingFace"""
        try:
            from transformers import AutoModelForCausalLM, AutoTokenizer
            
            log_dir = os.path.join(Path.home(), ".cache", "huggingface")
            
            tokenizer = AutoTokenizer.from_pretrained(
                self.model_path or "meta-llama/Llama-2-7b-chat-hf"
            )
            
            model = AutoModelForCausalLM.from_pretrained(
                self.model_path or "meta-llama/Llama-2-7b-chat-hf",
                device_map="auto",
                trust_remote_code=True
            )
            
            print("✅ Model loaded successfully")
            return model, tokenizer
            
        except Exception as e:
            print(f"❌ Failed to load model: {e}")
            return None, None
    
    def process(self, prompt):
        """Process input through the agent"""
        self.memory.append({"role": "user", "content": prompt})
        
        # Placeholder for processing logic
        response = f"Agent received: {prompt[:100]}..."
        
        self.memory.append({"role": "assistant", "content": response})
        return response
    
    def save_state(self):
        """Persist agent memory"""
        import json
        
        state_file = Path("./agent_state.json")
        with open(state_file, 'w') as f:
            json.dump(self.memory, f, indent=2)
        
        print(f"💾 State saved to {state_file}")


def main():
    """Entry point"""
    agent = AIAgent(max_tokens=2048)
    
    print("\n🤖 AI Agent Ready!")
    print("Type 'quit' to exit\n")
    
    while True:
        user_input = input("\nUser> ").strip()
        
        if user_input.lower() == 'quit':
            break
        
        if not user_input:
            continue
            
        response = agent.process(user_input)
        print(f"\nAssistant> {response}")
        
        # Auto-save every interaction
        agent.save_state()


if __name__ == "__main__":
    main()
EOF

    # Create requirements.txt
    cat > requirements.txt << 'EOF'
transformers>=4.35.0
torch>=2.0.0
accelerate>=0.24.0
datasets>=2.14.0
sentence-transformers>=2.2.0
langchain>=0.0.350
chromadb>=0.4.0
python-dotenv>=1.0.0
pyyaml>=6.0
EOF

    # Create config file
    cat > config.yaml << 'EOF'
agent:
  name: "${AGENT_NAME}"
  model_type: "llm"
  
llm:
  provider: "local"
  max_tokens: 2048
  temperature: 0.7
  
memory:
  enabled: true
  persistence: "json"
  
logging:
  level: "INFO"
  file: "agent.log"
EOF

    log_info "Project structure created"
}

optional_gpu_setup() {
    log_info "Checking GPU availability for CUDA acceleration..."
    
    if command -v nvidia-smi &> /dev/null; then
        log_info "NVIDIA GPU detected - installing CUDA support"
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
    else
        log_warn "No NVIDIA GPU found. Running on CPU."
        pip install torch torchvision torchaudio
    fi
}

create_startup_service() {
    log_info "Creating systemd service file..."
    
    cat > "/etc/systemd/system/${AGENT_NAME}.service" << EOF
[Unit]
Description=${AGENT_NAME} AI Agent Service
After=network.target

[Service]
Type=simple
User=$(whoami)
WorkingDirectory=$WORKSPACE_DIR
ExecStart=$WORKSPACE_DIR/venv/bin/python $WORKSPACE_DIR/agent.py
Restart=always
Environment="PATH=$WORKSPACE_DIR/venv/bin:$PATH"

[Install]
WantedBy=multi-user.target
EOF

    log_info "Service file created at /etc/systemd/system/${AGENT_NAME}.service"
    log_warn "Remember to enable with: sudo systemctl enable ${AGENT_NAME}"
}

#######################################
# Completion Message
#######################################
show_completion_message() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${GREEN}✓ SETUP COMPLETE!${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Workspace: $WORKSPACE_DIR"
    echo ""
    echo "Quick Start Commands:"
    echo "  cd $WORKSPACE_DIR"
    echo "  source venv/bin/activate"
    echo "  python agent.py"
    echo ""
    echo "Optional Features:"
    echo "  - For larger models: Consider quantized versions"
    echo "  - For GPU: Ensure CUDA drivers are installed"
    echo "  - For APIs: Set up .env with API keys"
    echo ""
    log_info "Need more help? Check documentation at:"
    echo "  - LangChain: https://python.langchain.com"
    echo "  - HuggingFace: https://huggingface.co/docs"
    echo "  - PyTorch: https://pytorch.org/docs"
    echo ""
}

#######################################
# Execution Flow
#######################################
main() {
    check_root
    
    if ! prompt_confirm "This will install ~2GB of dependencies. Continue?"; then
        log_info "Installation cancelled."
        exit 0
    fi
    
    install_system_packages
    setup_python_environment
    optional_gpu_setup
    install_llm_dependencies
    create_basic_agent_structure
    create_startup_service
    
    show_completion_message
}

# Run main function
"$@"
