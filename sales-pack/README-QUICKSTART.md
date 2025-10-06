# AxiomHive SSI v2.1 - Quick Start

## What You Need

- Docker installed (recommended)
- OR Node.js 20+ and Python 3.8+

## 5-Minute Setup

### Option 1: Docker (Easiest)

```bash
# Clone the repository
git clone https://github.com/AXI0MH1VE/SSI.git
cd SSI

# Setup and run
chmod +x scripts/*.sh
./scripts/setup.sh
./scripts/run-docker.sh
```

### Option 2: Local Development

```bash
# Clone and setup
git clone https://github.com/AXI0MH1VE/SSI.git
cd SSI
./scripts/setup.sh

# Run locally
./scripts/run-local.sh
```

## Test It

```bash
# Health check
curl http://localhost:3000/health

# Ask a question
curl -X POST http://localhost:3000/ask \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "What is the Axiom Dynamic Logic Model?",
    "enable_grounding": true
  }'
```

## What's Included

- **Offline AI**: ADLM runs 100% locally
- **REST API**: Simple POST /ask endpoint
- **Knowledge Base**: Local document grounding
- **Enterprise Ready**: Docker, validation, monitoring

## Next Steps

- See [ARCHITECTURE.md](../ARCHITECTURE.md) for technical details
- See [OPERATIONS.md](../OPERATIONS.md) for deployment guide
- See [SALES_ONE_PAGER.md](../SALES_ONE_PAGER.md) for business value
- See [SLA.md](../SLA.md) for service commitments
