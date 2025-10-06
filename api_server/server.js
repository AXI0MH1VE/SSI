const express = require('express');
const cors = require('cors');
const { spawn } = require('child_process');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Logging middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ADLM /ask endpoint
app.post('/ask', (req, res) => {
  const { prompt, enable_grounding = true } = req.body;
  
  if (!prompt) {
    return res.status(400).json({ error: 'Prompt is required' });
  }

  const pythonProcess = spawn('python3', [
    'api_server/axiom_model/axiom_model_handler.py',
    '--prompt', prompt,
    '--enable-grounding', enable_grounding.toString()
  ]);

  let output = '';
  let errorOutput = '';

  pythonProcess.stdout.on('data', (data) => {
    output += data.toString();
  });

  pythonProcess.stderr.on('data', (data) => {
    errorOutput += data.toString();
    console.error(`Python stderr: ${data}`);
  });

  pythonProcess.on('close', (code) => {
    if (code === 0) {
      try {
        const result = JSON.parse(output);
        res.json(result);
      } catch (e) {
        res.status(500).json({ error: 'Failed to parse Python output', details: output });
      }
    } else {
      res.status(500).json({ error: 'Python process failed', code, details: errorOutput });
    }
  });
});

app.listen(PORT, () => {
  console.log(`API server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`Ask endpoint: http://localhost:${PORT}/ask`);
});
