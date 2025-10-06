FROM node:20-slim

# Install Python
RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy application files
COPY axiom_model ./axiom_model
COPY api_server ./api_server

# Expose port
EXPOSE 3000

# Start command
CMD ["node", "api_server/index.js"]
