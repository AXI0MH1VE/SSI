#!/bin/bash
set -e

echo "=== Starting SSI ADLM v2.1 in Docker ==="

# Check if Docker is installed
command -v docker >/dev/null 2>&1 || { echo "Docker required"; exit 1; }

# Build the Docker image
echo "Building Docker image..."
docker build -t ssi-adlm:v2.1 .

# Run the container
echo "Starting container..."
docker run -d \
  --name ssi-adlm \
  -p 3000:3000 \
  -v $(pwd)/adlm:/app/adlm \
  ssi-adlm:v2.1

echo "Container started! API available at http://localhost:3000"
echo "Health check: curl http://localhost:3000/health"
echo "Stop with: docker stop ssi-adlm && docker rm ssi-adlm"
