const crypto = require("crypto");

const generateHmac = (msg, key) => {
  if (typeof msg !== "string") {
    msg = JSON.stringify(msg);
  }
  return crypto.createHmac("sha256", key).update(msg).digest("base64");
};

module.exports = { generateHmac };
