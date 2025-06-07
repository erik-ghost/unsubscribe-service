const express = require('express');

const app = express();

app.get('/unsubscribe', (req, res) => {
  const { uuid, key, newsletter } = req.query;

  if (!uuid || !key || !newsletter) {
    return res.status(400).send('Missing required query parameters: uuid, key, newsletter');
  }

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

  res.redirect(302, redirectUrl.toString());
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Express server listening on http://0.0.0.0:3000');
});