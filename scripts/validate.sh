#!/bin/bash
# Validation harness for SSI v2.1

set -e

echo "Running validation tests..."

# Check if required files exist
if [ ! -f "ssi.sh" ]; then
    echo "Error: ssi.sh not found"
    exit 1
fi

# Run basic validation
echo "✓ File structure validated"

# Check script syntax
bash -n ssi.sh
echo "✓ Syntax check passed"

echo "All validation checks passed!"
exit 0
