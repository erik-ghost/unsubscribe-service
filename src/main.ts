const express = require('express');
const https = require('https');

const app = express();

// In-memory queue of unsubscribe requests
const requestQueue = [];

// Interval in ms to process 1 request (limit to 5 requests per second)
const RATE_LIMIT_INTERVAL = 200;

// Consumer loop to process queue at fixed rate
setInterval(() => {
  if (requestQueue.length === 0) {
    return;
  }
  const { uuid, key, newsletter } = requestQueue.shift();

  const forwardUrl = new URL('https://ketchupisasauce.ghost.io/unsubscribe');
  forwardUrl.searchParams.append('uuid', String(uuid));
  forwardUrl.searchParams.append('key', String(key));
  forwardUrl.searchParams.append('newsletter', String(newsletter));

  https.get(forwardUrl.toString(), (response) => {
    console.log(`Response headers from ${forwardUrl.toString()}:`);
    console.log(response.headers);
  }).on('error', (err) => {
    console.error('Error making external request:', err.message);
  });
}, RATE_LIMIT_INTERVAL);

app.get('/unsubscribe', (req, res) => {
  const { uuid, key, newsletter } = req.query;

  if (!uuid || !key || !newsletter) {
    return res.status(400).send('Missing required query parameters: uuid, key, newsletter');
  }

  // Enqueue the request data for forwarding asynchronously
  requestQueue.push({ uuid, key, newsletter });

  // Use host header for constructing redirect URL to include port and preserve full incoming domain
  const host = req.get('host');
  if (!host) {
    return res.status(400).send('Invalid host header');
  }

  const redirectUrl = new URL(`http://${host}/`);
  redirectUrl.searchParams.append('uuid', String(uuid));
  redirectUrl.searchParams.append('key', String(key));
  redirectUrl.searchParams.append('newsletter', String(newsletter));
  redirectUrl.searchParams.append('action', 'unsubscribe');

  // Immediate response with 302 redirect
  res.redirect(302, redirectUrl.toString());
});

const server = app.listen(3000, '0.0.0.0', () => {
  console.log('Express server listening on http://0.0.0.0:3000');
});

// Graceful shutdown on SIGINT or SIGTERM
function shutdown() {
  console.log('Received shutdown signal, closing server...');
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });

  // Force exit after 5 seconds if not closed
  setTimeout(() => {
    console.error('Forcefully shutting down');
    process.exit(1);
  }, 5000);
}

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
