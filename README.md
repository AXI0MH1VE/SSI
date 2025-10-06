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

### Inference

```bash
POST /api/infer
Content-Type: application/json

{
  "prompt": "Your text here",
  "max_tokens": 100,
  "temperature": 0.7
}
```

## Architecture

- **API Server**: Express.js (Node.js) handles HTTP requests
- **ADLM Core**: Python-based transformer model for inference
- **Deployment**: Docker container with Node + Python runtime

## Files

- `api_server/server.js` - REST API implementation
- `adlm/` - Python ADLM model code
- `scripts/` - Setup and deployment scripts
- `Dockerfile` - Container definition

## License

See LICENSE file.
