const express = require("express");
const https = require("https");

const app = express();

app.get("/unsubscribe", (req, res) => {
  const { uuid, key, newsletter } = req.query;

  if (!uuid || !key || !newsletter) {
    return res
      .status(400)
      .send("Missing required query parameters: uuid, key, newsletter");
  }

  // Forward the request by making a GET request to https://ketchupisasauce.ghost.io/unsubscribe with same query parameters
  const forwardUrl = new URL("https://ketchupisasauce.ghost.io/unsubscribe/");
  if (uuid) forwardUrl.searchParams.append("uuid", String(uuid));
  if (key) forwardUrl.searchParams.append("key", String(key));
  if (newsletter)
    forwardUrl.searchParams.append("newsletter", String(newsletter));

  https
    .get(forwardUrl.toString(), (response) => {
      console.log(`Response headers from ${forwardUrl.toString()}:`);
      console.log(response.headers);
    })
    .on("error", (err) => {
      console.error("Error making external request:", err.message);
    });

  // Use host header for constructing redirect URL to include port and preserve full incoming domain
  const host = req.get("host");
  if (!host) {
    return res.status(400).send("Invalid host header");
  }

  const redirectUrl = new URL(`http://${host}/`);
  redirectUrl.searchParams.append("uuid", String(uuid));
  redirectUrl.searchParams.append("key", String(key));
  redirectUrl.searchParams.append("newsletter", String(newsletter));
  redirectUrl.searchParams.append("action", "unsubscribe");

  res.redirect(302, redirectUrl.toString());
});

const server = app.listen(3000, "0.0.0.0", () => {
  console.log("Express server listening on http://0.0.0.0:3000");
});

// Graceful shutdown on SIGINT or SIGTERM
function shutdown() {
  console.log("Received shutdown signal, closing server...");
  server.close(() => {
    console.log("Server closed");
    process.exit(0);
  });

  // Force exit after 5 seconds if not closed
  setTimeout(() => {
    console.error("Forcefully shutting down");
    process.exit(1);
  }, 5000);
}

process.on("SIGINT", shutdown);
process.on("SIGTERM", shutdown);
