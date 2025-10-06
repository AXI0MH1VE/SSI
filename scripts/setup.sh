#!/bin/bash
set -e

echo "=== SSI ADLM v2.1 Setup ==="

# Check for required tools
command -v python3 >/dev/null 2>&1 || { echo "Python 3 required"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "Node.js required"; exit 1; }

# Install Python dependencies
echo "Installing Python dependencies..."
pip3 install --upgrade pip
pip3 install torch transformers numpy

# Install Node.js dependencies
echo "Installing Node.js dependencies..."
cd api_server
npm install
cd ..

echo "Setup complete! Run scripts/run-docker.sh to start the service."
