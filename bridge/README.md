# Ollama bridge

## Local-only by default
The bridge defaults to Ollama at `127.0.0.1:11434` and should be run on loopback first. For iOS LAN access, bind to a specific trusted LAN interface only after configuring firewall rules and authentication. Never expose Ollama's port 11434 directly to the public internet.

This starter has no shell/file execution tool. It forwards chat prompts only and does not edit the workbook or execute generated code.

## Run
```bash
python -m venv .venv
# Windows: .venv\\Scripts\\activate
# macOS/Linux:
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
uvicorn app:app --host 127.0.0.1 --port 8787
```

Health check: `GET http://127.0.0.1:8787/health`  
Chat: `POST http://127.0.0.1:8787/chat`
