# AetherForge Virtual Compute Rack

**Developer:** Stephen Delaine junior  
**Build ID:** AFVCR-2026-10-29-001  
**Version:** 1.1.0

A starter repository for the AetherForge virtual compute configuration workbook, a Python/FastAPI bridge to a locally hosted Ollama model, and a SwiftUI iOS client scaffold.

## Components
- `bridge/app.py`: read-only chat API forwarding prompts to Ollama.
- `bridge/requirements.txt`: Python dependencies.
- `bridge/.env.example`: model and endpoint configuration.
- `ios/AetherForgeApp.swift`: SwiftUI client starter.
- `BUILD_STATUS.md`: confirmed implementation status and remaining work.
- Workbook design: 64-bit default architecture; emulated datapath widths up to 1024 bits; 9.99 GHz CPU/GPU values are simulation targets; 24 × 32 TB virtual SSDs = 768 TB raw logical capacity.

## Run the bridge
1. Install Ollama on a trusted computer and pull a compatible model, e.g. `ollama pull qwen2.5:7b`.
2. In `bridge/`, create and activate a Python virtual environment.
3. Run `pip install -r requirements.txt`.
4. Copy `.env.example` to `.env` and configure as needed.
5. Run `uvicorn app:app --host 127.0.0.1 --port 8787`.
6. Check `GET /health`; send chat requests to `POST /chat`.

The iOS app requires Xcode on macOS to compile and sign. Set `bridgeURL` to a reachable bridge address. For LAN access, configure firewall rules and authentication first.

## Security and scope
Keep Ollama and the bridge off the public internet. The bridge is a development starter, not production-hardened. This repository does not claim a physical 9.99 GHz CPU/GPU; those values are simulation targets. No iOS build or live Ollama integration is claimed as tested.
