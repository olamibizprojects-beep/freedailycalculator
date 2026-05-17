const path = require('path');
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Security: CORS configuration - adjust for your domain
const allowedOrigins = process.env.ALLOWED_ORIGINS
  ? process.env.ALLOWED_ORIGINS.split(',').map(origin => origin.trim()).filter(Boolean)
  : ['http://localhost:3000', 'https://yourdomain.com'];

const corsOptions = {
  origin: allowedOrigins,
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type', 'Authorization']
};

app.use(cors(corsOptions));
app.use(express.json({ limit: '10kb' })); // Prevent large payloads

// Rate limiting (simple in-memory)
const requestCounts = new Map();
const RATE_LIMIT = 50; // requests per hour per IP
const RATE_WINDOW = 60 * 60 * 1000;

function rateLimit(req, res, next) {
  const ip = req.ip || req.connection.remoteAddress;
  const now = Date.now();

  if (!requestCounts.has(ip)) {
    requestCounts.set(ip, { count: 1, resetTime: now + RATE_WINDOW });
  } else {
    const data = requestCounts.get(ip);
    if (now > data.resetTime) {
      data.count = 1;
      data.resetTime = now + RATE_WINDOW;
    } else {
      data.count++;
    }
  }

  const data = requestCounts.get(ip);
  if (data.count > RATE_LIMIT) {
    return res.status(429).json({ error: 'Rate limit exceeded. Try again later.' });
  }

  res.setHeader('X-RateLimit-Remaining', RATE_LIMIT - data.count);
  next();
}

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// DeepSeek AI Chat Proxy
app.post('/api/chat', rateLimit, async (req, res) => {
  try {
    const { message } = req.body;

    if (!message || typeof message !== 'string' || message.length > 1000) {
      return res.status(400).json({ error: 'Invalid message. Max 1000 characters.' });
    }

    const DEEPSEEK_API_KEY = process.env.DEEPSEEK_API_KEY;
    if (!DEEPSEEK_API_KEY) {
      return res.status(503).json({ error: 'AI service not configured' });
    }

    const response = await fetch('https://api.deepseek.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${DEEPSEEK_API_KEY}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        model: 'deepseek-chat',
        messages: [
          { 
            role: 'system', 
            content: 'You are a helpful financial education assistant. Provide general guidance, not professional financial advice. Keep responses under 150 words. Be concise and actionable.' 
          },
          { role: 'user', content: message }
        ],
        max_tokens: 300,
        temperature: 0.7
      })
    });

    if (!response.ok) {
      const errorData = await response.text();
      console.error('DeepSeek API error:', errorData);
      return res.status(502).json({ error: 'AI service temporarily unavailable' });
    }

    const data = await response.json();
    const reply = data.choices?.[0]?.message?.content || 'No response from AI';

    res.json({ 
      reply,
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Server error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Serve static files (frontend)
const staticPath = path.join(__dirname);
const blockedPaths = new Set([
  '/server.js',
  '/package.json',
  '/package-lock.json',
  '/.env',
  '/README.md',
  '/DEPLOYMENT.md'
]);

app.use((req, res, next) => {
  if (blockedPaths.has(req.path)) {
    return res.status(404).end();
  }
  next();
});

app.use(express.static(staticPath, { index: false }));

// SPA fallback for hash routing
app.get('*', (req, res) => {
  res.sendFile(path.join(staticPath, 'index.html'));
});

app.listen(PORT, () => {
  console.log(`🚀 FinanceTools Pro server running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/api/health`);
});
