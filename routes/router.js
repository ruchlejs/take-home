router = require("express").Router();
crypt = require("../controllers/crypt");

router.get("/", (req, res) => {
  res.send("hello world");
});

router.post("/encrypt", crypt.encrypt);
router.post("/decrypt", crypt.decrypt);
router.post("/sign", crypt.sign);
router.post("/verify", crypt.verify);

module.exports = router;
