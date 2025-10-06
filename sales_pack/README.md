# SSI ADLM v2.1

Adaptive Deep Learning Model (ADLM) system with REST API.

## Quickstart

### Docker (Recommended)

```bash
# Run setup
chmod +x scripts/*.sh
./scripts/setup.sh

# Start with Docker
./scripts/run-docker.sh
```

### Local Development

```bash
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

Returns: `{"status": "ok", "timestamp": "..."}`

### Ask Endpoint

```bash
POST /ask
Content-Type: application/json

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

Response:
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
