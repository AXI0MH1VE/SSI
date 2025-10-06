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
  "enable_grounding": true
}
```

#### Example with curl

```bash
curl -X POST http://localhost:3000/ask \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "What is the Axiom Dynamic Logic Model?",
    "enable_grounding": true
  }'
```

**Response:**
```json
{
  "response": "The ADLM response text...",
  "grounded": true
}
```

## Architecture

• API Server: Express.js (Node.js) handles HTTP requests  
• ADLM Core: Python-based transformer model for inference  
• Deployment: Docker container with Node + Python runtime

## Files

• api_server/server.js - REST API implementation  
• api_server/axiom_model/ - Python ADLM model code  
• scripts/ - Setup and deployment scripts  
• Dockerfile - Container definition

## License

See LICENSE file.
