const app = require("./index.js");
const request = require("supertest");

describe("POST /encrypt", () => {
  test("test of encryption of JSON payload", async () => {
    const response = await request(app)
      .post("/encrypt")
      .send({
        foo: "foobar",
        bar: {
          isbar: true,
        },
      });

    expect(response.statusCode).toBe(200);

    expect(response.body).toHaveProperty("foo");
    expect(response.body).toHaveProperty("bar");
  });
});

describe("POST /decrypt", () => {
  test("test of decryption of JSON payload", async () => {
    const response = await request(app).post("/decrypt").send({
      foo: "Zm9vYmFy",
      bar: "eyJpc0JhciI6dHJ1ZX0=",
    });

    expect(response.statusCode).toBe(200);

    const decrypted = response.body;
    expect(decrypted.foo).toBe("foobar");
    expect(decrypted.bar).toEqual({ isBar: true });
  });
});

describe("POST /sign", () => {
  test("test of creation of a signature with JSON payload", async () => {
    const response = await request(app).post("/sign").send({
      test: "I am testing the signing",
    });

    expect(response.statusCode).toBe(200);
  });
});

describe("POST /verify", () => {
  test("test if we detect a wrong signature", async () => {
    const response = await request(app).post("/verify").send({
      signature: "wrongSign",
      data: {},
    });

    expect(response.statusCode).toBe(400);
  }),
    test("test of the necesity of the signature key", async () => {
      const response = await request(app).post("/verify").send({
        data: {},
      });

      expect(response.statusCode).toBe(400);
      expect(response.body.status).toBe(false);
    });

  test("test of the necesity of the data key", async () => {
    const response = await request(app).post("/verify").send({
      signature: "sign",
    });

    expect(response.statusCode).toBe(400);
    expect(response.body.status).toBe(false);
  });

  test("test of provided the same signature previously generated", async () => {
    const response = await request(app)
      .post("/verify")
      .send({
        signature: "X55eFovc4SCLnVgdALVdOv6LjfAWycpt5IKuExTXJjs=",
        data: {
          test: "I am testing the signing",
        },
      });

    expect(response.statusCode).toBe(204);
  });
});
