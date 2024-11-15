const crypto = require("crypto");
const has = require("has-keys");

// Normally, I would store this key in a .env file to keep it secure and out of the codebase.
// However, for debugging purposes, I'm temporarily keeping it here.
const { generateHmac } = require("../util/hmac");
const key = "AAAA";

module.exports = {
  encrypt(req, res) {
    const body = req.body;
    const encrypted_json = {};

    for (const parse_body_key in body) {
      if (typeof body[parse_body_key] === "object") {
        const encode_value = Buffer.from(
          JSON.stringify(body[parse_body_key])
        ).toString("base64");
        encrypted_json[parse_body_key] = encode_value;
      } else {
        const encode_value = Buffer.from(body[parse_body_key]).toString(
          "base64"
        );
        encrypted_json[parse_body_key] = encode_value;
      }
    }

    res.status(200).json(encrypted_json);
  },

  decrypt(req, res) {
    const body = req.body;
    const decrypted_json = {};
    for (parse_body_key in body) {
      try {
        decrypted_json[parse_body_key] = JSON.parse(
          Buffer.from(body[parse_body_key], "base64").toString()
        );
      } catch {
        decrypted_json[parse_body_key] = Buffer.from(
          body[parse_body_key],
          "base64"
        ).toString();
      }
    }

    res.status(200).json(decrypted_json);
  },

  sign(req, res) {
    const msg = JSON.stringify(req.body);
    const hmac_signature = generateHmac(msg, key);

    res.status(200).json(hmac_signature);
  },

  verify(req, res) {
    const body = req.body;
    if (!has(req.body, ["signature", "data"])) {
      return res.status(400).json({
        status: false,
        msg: "you should provide a signature field and a data field.",
      });
    }
    let given_sign = body.signature;

    const computed_sign = generateHmac(body.data, key);

    if (given_sign === computed_sign) {
      res.status(204).send();
    } else {
      res.status(400).json({ msg: "different signature" });
    }
  },
};
