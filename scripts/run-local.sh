#!/bin/bash
# Run local development server for SSI ADLM v2.1
set -e

echo "Starting SSI ADLM local server..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed"
    exit 1
fi

# Install Node.js dependencies
if [ -f "api_server/package.json" ]; then
    echo "Installing Node.js dependencies..."
    cd api_server && npm install && cd ..
fi

# Create local_storage directory if it doesn't exist
mkdir -p local_storage

# Start the API server
echo "Starting API server on port 3000..."
node api_server/server.js
