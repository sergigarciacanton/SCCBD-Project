# SCCBD-Project

Repository for Cibersecurity part of subject Smart Cities: Ciberseguretat i Big Data.

This repo contains modules and apps for both the class regular modules and the project modules. More precisely, this is the list of folders (one module in each one) used by each part:

- Modules:
   - rsa-module
   - paillier-module
   - shamir-module
   - Node-Express-API
   - Angular-Client
- Project:
   - flutter_bigint_conversion
   - flutter_bigint_crypto_utils
   - flutter_rsa_module
   - flutter_project_frontend
   - project_backend
   - rsa-module

## rsa-module

This folder contains a `npm` module for generating RSA key pairs and performing several calculations with them (encrypt, sign...). It also contains methods for sending and receiving public keys and any bigint as base64 strings to/from other devices

This module's dependencies are `npm` modules `bigint-crypto-utils` and `bigint-conversion`, which can be installed with the following console commands:

```console
npm install bigint-crypto-utils
npm install bigint-conversion
```

**Usage:**

```typescript
import * as rsa from "./index";
import * as bc from "bigint-conversion";

const keys: rsa.KeyPair = await rsa.generateKeyPair(1024);  // Generate a pair of 1024 bits long RSA keys

const plaintext: string = "1234567890";

const ciphertext: bigint = keys.pubKey.encrypt(bc.textToBigint(plaintext));  // Encrypt a message
const decrypted = bc.bigintToText(keys.privKey.decrypt(ciphertext));  // Decrypt a message

const signed = keys.privKey.sign(plaintext);  // Sign a message
const verified = keys.pubKey.verify(signed);  // Verify a message

const jsonMessage = rsa.JsonMessage.toJSON(verified);
const jsonParsed = rsa.JsonMessage.fromJSON(jsonMessage);

const jsonPubKey = this.keys.pubKey.toJSON();
const pubKey: rsa.RsaPubKey = rsa.RsaPubKey.fromJSON(jsonPubKey);
```

**Build:**

In order to build the source code of this module, it is enough with typing the following console command: `npm run build`

## paillier-module

This folder contains a `npm` module for generating key pairs for using on the Paillier cryptosystem and performing several calculations with them (encrypt, sign...). It also contains methods for sending and receiving public keys and any bigint as base64 strings to/from other devices

This module's dependencies are `npm` modules `bigint-conversion` and `paillier-bigint`, which can be installed with the following console commands:

```console
npm install bigint-conversion
npm install paillier-bigint
```

**Usage:**

```typescript
import * as paillier from "./index";
import * as bc from "bigint-conversion";

const { pubKey, privKey } = await paillier.generateKeyPair(3072);

const m1: bigint = 1234567890n;
const m2: bigint = 1n;

const c1: bigint = pubKey.encrypt(m1);
const c2: bigint = pubKey.encrypt(m2);

const encryptedSum: bigint = pubKey.add(c1, c2);

const k: bigint = 2n;
const encryptedMul: bigint = pubKey.multiply(c1, k);

const decrypted = privKey.decrypt(encryptedMul);
```

**Build:**

In order to build the source code of this module, it is enough with typing the following console command: `npm run build`

## shamir-module

This folder contains a `npm` module for generating key pairs for using on the Shamir threshold cryptosystem and performing several calculations with them (encrypt, sign...). It also contains methods for sending and receiving public keys and any bigint as base64 strings to/from other devices

This module's dependencies are `npm` modules `bigint-crypto-utils` and `bigint-conversion`, which can be installed with the following console commands:

```console
npm install bigint-crypto-utils
npm install bigint-conversion
```

**Usage:**

```typescript
import * as shamir from "./index";
import * as bcu from "bigint-crypto-utils";

const bitLength: number = 2048;
const outKeys: number = 5;
const threshold: number = 3;
const p: bigint = await bcu.prime(bitLength);

const secret = bcu.randBetween(p);
const sx: shamir.ShamirShare[] = await shamir.generateShares(
  secret,
  threshold,
  outKeys,
  p
);

let sx2 = [sx[0], sx[1], sx[3]];

let s = shamir.getSecret(sx2, p);

sx[3].y += 3n;
sx2 = [sx[0], sx[1], sx[3]];

s = shamir.getSecret(sx2, p);
```

**Build:**

In order to build the source code of this module, it is enough with typing the following console command: `npm run build`

## Node-Express-API

This folder contains a `npm` module which has an express web server where users can connect for testing the modules described previously.

This module's dependencies are `npm` modules `rsa-module`, `paillier-module` and `shamir-module`, which can be installed with the following console commands:

```console
npm install ../rsa-module
npm install ../paillier-module
npm install ../shamir-module
```

**Endpoints:**

- rsaRoutes
  - GET getAPIUsage ( / ): Returns a string with all necessary information for using the rest of endpoints of the service
  - GET getPubKey ( /getPubKey ): Returns the server's RSA public key in base64 format
  - POST encrypt ( /encrypt ): Returns a base64-encoded bigint containing the encrypted message given as a body parameter (NOTE: Not for actual usage, use only for testing purposes)
  - POST decrypt ( /decrypt ): Returns a base64-encoded bigint containing the decrypted message given as a body parameter
  - POST sign ( /sign ): Returns a base64-encoded bigint containing the signed message given as a body parameter
  - POST verify ( /verify ): Returns a base64-encoded bigint containing the verified message given as a body parameter (NOTE: Not for actual usage, use only for testing purposes)
- paillierRoutes
  - GET getAPIUsage ( / ): Returns a string with all necessary information for using the rest of endpoints of the service
  - GET getPubKey ( /getPubKey ): Returns the server's Paillier public key in base64 format
  - POST encrypt ( /encrypt ): Returns a base64-encoded bigint containing the encrypted message given as a body parameter (NOTE: Not for actual usage, use only for testing purposes)
  - POST decrypt ( /decrypt ): Returns a base64-encoded bigint containing the decrypted message given as a body parameter

**Set up:**

Follow these steps in order to set up the server:

- Import all necessary dependencies by typing the console command `npm install`
- Start Typescript transpiler in watch mode by typing the console command `npm run ts`
- Start the server listening for changes with nodemon typing on a new terminal the console command `npm run dev` (the previous one will be in use for the transpiler's listener)





