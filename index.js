const express = require("express");
const app = express();

const PORT = 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/", require("./routes/router.js"));

app.use("*", (req, res, next) => {
  res.setHeader("Content-Type", "application/json");
  next();
});

app.listen(PORT, () => console.info("Server listenning on port ", PORT));
