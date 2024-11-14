module.exports = {
  async encrypt(req, res) {
    const body = req.body;
    encrypted_json = {};

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
    decrypted_json = {};
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

  sign(req, res) {},
};
