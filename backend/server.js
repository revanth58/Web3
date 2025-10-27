// server.js
const express = require("express");
const path = require("path");
const app = express();
const PORT = 3000;

// Serve index.html on GET /
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "index.html"));
});

// Placeholder function for handling a transaction (not wired yet)
function handleTransaction(sender, receiver, amount) {
  // For now just log it, tomorrow we make real endpoint logic
  console.log(`Transaction Requested:
  From: ${sender}
  To: ${receiver}
  Amount: ${amount}`);

  // Will eventually return success/fail based on blockchain call
  return { status: "pending", message: "Transaction function placeholder" };
}

module.exports = { handleTransaction };

// Start server
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
