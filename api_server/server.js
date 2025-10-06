const express = require('express');
const cors = require('cors');
const Redis = require('ioredis');
const { v4: uuidv4 } = require('uuid');
const config = require('../config/default.json');

const app = express();
const PORT = config.api.port || 3000;

// Redis clients
const redisClient = new Redis({
  host: config.redis.host,
  port: config.redis.port
});

app.use(cors({ origin: config.api.corsOrigins }));
app.use(express.json());

// Logging middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    redis: redisClient.status 
  });
});

// ADLM /ask endpoint with Redis queue
app.post('/ask', async (req, res) => {
  const { prompt, enable_grounding = true } = req.body;
  
  if (!prompt) {
    return res.status(400).json({ error: 'Prompt is required' });
  }

  try {
    const jobId = uuidv4();
    const job = {
      id: jobId,
      prompt,
      enable_grounding,
      timestamp: new Date().toISOString()
    };

    // Push job to Redis queue (LPUSH)
    await redisClient.lpush(config.redis.queueName, JSON.stringify(job));
    console.log(`Job ${jobId} pushed to queue`);

    // Wait for result from response queue (BRPOP with timeout)
    const responseKey = `${config.redis.queueName}:response:${jobId}`;
    const timeout = Math.floor(config.api.requestTimeout / 1000); // Convert to seconds
    const result = await redisClient.brpop(responseKey, timeout);

    if (!result) {
      return res.status(504).json({ 
        error: 'Request timeout', 
        jobId 
      });
    }

    const [, responseData] = result;
    const response = JSON.parse(responseData);

    if (response.error) {
      return res.status(500).json(response);
    }

    res.json(response);
  } catch (error) {
    console.error('Error processing request:', error);
    res.status(500).json({ 
      error: 'Internal server error', 
      details: error.message 
    });
  }
});

app.listen(PORT, () => {
  console.log(`API server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`Ask endpoint: http://localhost:${PORT}/ask`);
  console.log(`Redis connected: ${config.redis.host}:${config.redis.port}`);
});
