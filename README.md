![GitHub stars](https://img.shields.io/github/stars/AXI0MH1VE/SSI?style=social)
![GitHub followers](https://img.shields.io/github/followers/AXI0MH1VE?style=social)
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=AXI0MH1VE/SSI)

# SSI ADLM v2.1
Adaptive Deep Learning Model (ADLM) system with REST API.
## Principles
### User Full Control
- Offline-by-default; no external API calls
- All data and logs stored locally under local_storage/
- Deterministic behavior; identical inputs yield identical outputs
- No hidden configuration; all runtime flags are visible in README and scripts
### Full Transparency
- Clear, inspectable ADLM logic in axiom_model/axiom_model_handler.py
- Local knowledge base in axiom_model/knowledge_base.json
- Per-request JSON audit logs including telemetry and cost_summary
- Architecture, operations, security, SLA, and EULA published in repo and sales_pack/
## Quickstart
### Docker (Recommended)
```bash
# Make scripts executable
chmod +x scripts/*.sh
# Run setup
./scripts/setup.sh
# Start with Docker
./scripts/run-docker.sh
```
### Local Development
```bash
# Make scripts executable
chmod +x scripts/*.sh
# Install dependencies
./scripts/setup.sh
# Run locally
./scripts/run-local.sh
```
## API Endpoints
### Health Check
```bash
GET /health
```
**Response:**
```json
{
  "status": "ok",
  "timestamp": "2025-10-06T16:39:00.000Z"
}
```
### Ask Endpoint
```bash
POST /ask
Content-Type: application/json
```
**Request Body:**
```json
{
  "prompt": "Your question here",
