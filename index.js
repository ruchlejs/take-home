const express = require("express");
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/", require("./routes/router.js"));

app.use("*", (req, res, next) => {
  res.setHeader("Content-Type", "application/json");
  next();
});

// Handle not valid route
app.use("*", (req, res) => {
  res.status(404).json({ status: false, message: "Endpoint Not Found" });
});

// app.listen(PORT, () => console.info("Server listenning on port ", PORT));
module.exports = app;
