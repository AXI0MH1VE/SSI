# Stage 1 removed: Rust not used in v1.0
FROM node:20-slim
WORKDIR /app
RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*
COPY any-hardware-axiomhive/gemini_handler/requirements.txt gemini_handler/requirements.txt
RUN pip3 install --no-cache-dir -r gemini_handler/requirements.txt
COPY any-hardware-axiomhive/api_server/package*.json any-hardware-axiomhive/api_server/
RUN cd any-hardware-axiomhive/api_server && npm install
COPY any-hardware-axiomhive/api_server/server.js any-hardware-axiomhive/api_server/server.js
COPY any-hardware-axiomhive/gemini_handler/gemini_handler.py any-hardware-axiomhive/gemini_handler/gemini_handler.py
COPY any-hardware-axiomhive/scripts any-hardware-axiomhive/scripts
COPY any-hardware-axiomhive/validation any-hardware-axiomhive/validation
COPY any-hardware-axiomhive/.env.example .env.example
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "any-hardware-axiomhive/api_server/server.js"]
