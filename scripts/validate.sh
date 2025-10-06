#!/bin/bash
# Validation harness for SSI v2.1
set -e

echo "Running validation tests..."

# Check if API is running
if ! curl -s http://localhost:3000/health > /dev/null; then
    echo "Error: API server not responding at http://localhost:3000"
    exit 1
fi

echo "✓ API server is running"

# Check if test request file exists
if [ ! -f "validation/test_request.json" ]; then
    echo "Error: validation/test_request.json not found"
    exit 1
fi

echo "✓ Test request file found"

# Send test request to /ask endpoint
echo "Sending test request to /ask endpoint..."
RESPONSE=$(curl -s -X POST http://localhost:3000/ask \
    -H "Content-Type: application/json" \
    -d @validation/test_request.json)

if [ $? -eq 0 ]; then
    echo "✓ Request successful"
    echo "Response: $RESPONSE"
else
    echo "Error: Request failed"
    exit 1
fi

echo "All validation checks passed!"
exit 0
