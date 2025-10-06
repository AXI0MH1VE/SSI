# SSI ADLM v2.1 Dockerfile
FROM node:18-slim

# Install Python and dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY api_server/package*.json ./api_server/
RUN cd api_server && npm ci --only=production

# Copy application files
COPY api_server/ ./api_server/
COPY adlm/ ./adlm/

# Install Python dependencies
RUN pip3 install --no-cache-dir torch transformers numpy

# Expose API port
EXPOSE 3000

# Start the API server
CMD ["node", "api_server/server.js"]
