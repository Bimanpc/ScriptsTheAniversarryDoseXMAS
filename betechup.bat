@echo off
REM ================================
REM LLM Linux Mint server launcher
REM From Windows .bat
REM ================================

REM ---- CONFIG ----
set LLM_HOST=192.168.1.50
set LLM_USER=llmuser
set LLM_PORT=22

REM Command to run on Linux (edit this!)
REM Example: start a FastAPI/uvicorn LLM backend
set LLM_CMD=cd /home/llmuser/llm-server && source venv/bin/activate && uvicorn app:app --host 0.0.0.0 --port 8000

echo Connecting to %LLM_USER%@%LLM_HOST% ...

ssh -p %LLM_PORT% %LLM_USER%@%LLM_HOST% "%LLM_CMD%"

echo.
echo LLM server command finished (or SSH session closed).
pause
