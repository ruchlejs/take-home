[Solution](#Solution)

# Riot Takehome Task Specification

Your task is to implement a REST API which:

1. Has two endpoints `/encrypt` and `/decrypt`. Each endpoint should take
   a JSON payload.
2. Use **Base64** to implement encryption and decryption on the
   `/encrypt` and `/decrypt` endpoints respectively.

   - `/encrypt` should encrypt every value in the object (at a depth of 1), returning the encrypted payload as JSON.
   - `/decrypt` should detect encrypted strings and decrypt them, returning the decrypted payload as JSON.

   For example:

   ```JSON
   {
     "foo": "foobar",
     "bar": {
       "isBar": true
     }
   }
   ```

   would become

   ```JSON
   {
     "foo": "some_encrypted_string",
     "bar": "some_encrypted_string"
   }
   ```

3. The **Base64** encryption algorithm should be easily replaceable with another algorithm without requiring significant changes to the codebase.
4. Create a `/sign` endpoint which takes a JSON payload and computes a
   cryptographic signature for the plaintext payload in HMAC. The signature is then
   sent in a JSON response.
5. Create a `/verify` endpoint, which takes a JSON payload of the form

```js
{
   "signature": "<COMPUTED_SIGNATURE>",
   "data": {
      // ...
   }
}
```

- Data can be any JSON object.
- If the provided signature matches the computed signature, the response code should be `204`; otherwise, it should be `400`.

Send me the project, your GitHub repository by email louis@tryriot.com.

# Solution

This problem has been addressed in JavaScript using Node.js. I created a backend with Express to manage the different endpoints.

I used the following modules to implement the solution:

- express
- has-keys
- jest
- nodemon
- supertest

You can install those by using this command:

```bash
npm install
```

## Execution

You can start the server by using:

```bash
npm run start
```

If you want to start it in development mode, use:

```bash
npm run dev
```

## Tests

Some tests have been included to verify the proper behavior of the program. You can run them with the following command:

```bash
npm run test
```
