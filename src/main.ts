import express from 'express';

const app = express();

app.get('/unsubscribe', (req, res) => {
  console.log('hello world');
  res.sendStatus(200);
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});