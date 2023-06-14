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
   - project_backend
   - flutter_project_frontend
   - rsa-module
   
Moreover, this repo also contains a JSON file that can be loaded on Insomnia for testing servers' behaviour

## rsa-module

This folder contains a `npm` module for generating RSA key pairs and performing several calculations with them (encrypt, sign...). It also contains methods for sending and receiving public keys and any bigint as base64 strings to/from other devices

This module's dependencies are `npm` modules `bigint-crypto-utils` and `bigint-conversion`, which can be installed with the following console commands:

```console
npm install bigint-crypto-utils
npm install bigint-conversion
```

**Install:**

As this module is not part of any npm package (it is just a local module) it has to be installed in other modules using the path to the root of this module. For instance, considering the case of a module located in a folder at the root of this repo, the console command would be as follows:

```console
npm install ../rsa-module
```

**Usage:**

```typescript
import * as rsa from "../rsa-module";
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

**Install:**

As this module is not part of any npm package (it is just a local module) it has to be installed in other modules using the path to the root of this module. For instance, considering the case of a module located in a folder at the root of this repo, the console command would be as follows:

```console
npm install ../paillier-module
```

**Usage:**

```typescript
import * as paillier from "../paillier-module";
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

**Install:**

As this module is not part of any npm package (it is just a local module) it has to be installed in other modules using the path to the root of this module. For instance, considering the case of a module located in a folder at the root of this repo, the console command would be as follows:

```console
npm install ../shamir-module
```

**Usage:**

```typescript
import * as shamir from "../shamir-module";
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

This module's dependencies are `npm` modules `rsa-module` and `paillier-module`, which can be installed with the following console commands:

```console
npm install ../rsa-module
npm install ../paillier-module
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

The API's base URL is localhost:3000/api

**Set up:**

Follow these steps in order to set up the server:

- Import all necessary dependencies by typing the console command `npm install`
- Start Typescript transpiler in watch mode by typing the console command `npm run ts`
- Start the server listening for changes with nodemon typing on a new terminal the console command `npm run dev` (the previous one will be in use for the transpiler's listener)

The default configuration starts the server listening at localhost on TCP port `3000`

## Angular-Client
 
This folder contains an Angular client that allows a user to test the server of the module Node-Express-API in a friendly way.

This module's dependencies are `npm` modules `bigint-crypto-utils`, `bigint-conversion`, `rsa-module` and `paillier-module`, which can be installed with the following console commands:

```console
npm install bigint-crypto-utils
npm install bigint-conversion
npm install ../rsa-module
npm install ../paillier-module
```

**Set up:**

Follow these steps in order to set up the client:

- Import all necessary dependencies by typing the console command `npm install`
- Start the Angular client by typing the console command `ng serve`

The default configuration starts the client at localhost on TCP port `4200`. Now it is possible to get the client using any web browser

## flutter_bigint_conversion

This folder contains a `flutter` module that has the same usage than `npm` module `bigint-conversion`, but this one is written in Dart code so it can be used in Flutter projects

For installing all necessary dependencies, it is enough with typing the following console command:

```console
flutter pub get
```

**Install:**

As this module is not part of any pub package (it is just a local module) it has to be installed in other modules using the path to the root of this module. For instance, considering the case of a module located in a folder at the root of this repo, the following code lines should be added into the dependencies section of `pubspec.yaml`:

```yaml
flutter_bigint_conversion:
  path: ../flutter_bigint_conversion
```

After saving the file, `flutter pub get` should run by itself. If not, please type the console command `flutter pub get`

**Usage:**

```dart
import 'package:flutter_bigint_conversion/flutter_bigint_conversion.dart';

var message = 'Hello World!';

var big = textToBigint(message);

var hex = bigintToHex(big);
var buf = hexToBuf(hex);
var b64 = bufToBase64(buf);

var buf2 = base64ToBuf(b64);
var hex2 = bufToHex(buf2);
var big2 = hexToBigint(hex2);

var b64_2 = bigintToBase64(big);
var big3 = base64ToBigint(b64_2);

var message2 = bigintToText(big3);
```

## flutter_bigint_crypto_utils

This folder contains a `flutter` module that implements the methods from `npm` module `bigint-crypto-utils` that do not exist in the core of Dart language

For installing all necessary dependencies, it is enough with typing the following console command:

```console
flutter pub get
```

**Install:**

As this module is not part of any pub package (it is just a local module) it has to be installed in other modules using the path to the root of this module. For instance, considering the case of a module located in a folder at the root of this repo, the following code lines should be added into the dependencies section of `pubspec.yaml`:

```yaml
flutter_bigint_crypto_utils:
  path: ../flutter_bigint_conversion
```

After saving the file, `flutter pub get` should run by itself. If not, please type the console command `flutter pub get`

**Usage:**

```dart
import 'package:flutter_bigint_crypto_utils/flutter_bigint_crypto_utils.dart';
import 'dart:math';

var bitLength = 1024;
final primeNum = prime(bitLength);
final prime = isProbablyPrime(primeNum, Random.secure());
```

## flutter_rsa_module

This folder contains a `flutter` module that has the same usage than our local `npm` module `rsa-module`, but this one is written in Dart code so it can be used in Flutter projects

For installing all necessary dependencies, it is enough with typing the following console command:

```console
flutter pub get
```

**Install:**

As this module is not part of any pub package (it is just a local module) it has to be installed in other modules using the path to the root of this module. For instance, considering the case of a module located in a folder at the root of this repo, the following code lines should be added into the dependencies section of `pubspec.yaml`:

```yaml
flutter_rsa_module:
  path: ../flutter_rsa_module
```

After saving the file, `flutter pub get` should run by itself. If not, please type the console command `flutter pub get`

**Usage:**

```dart
import 'package:flutter_bigint_conversion/flutter_bigint_conversion.dart';
import 'package:flutter_rsa_module/flutter_rsa_module.dart';

var keyLength = 1024;
KeyPair keyPair = generateKeyPair(keyLength);

var message = 'Holahola';

var encrypted = keyPair.pubKey.encrypt(textToBigint(message));
var decrypted = keyPair.privKey.decrypt(encrypted);

var signed = keyPair.privKey.sign(textToBigint(message));
var verified = keyPair.pubKey.verify(signed);
```

## project_backend

This folder contains a `npm` module which has an express web server where users can connect for testing the modules described previously.

This module's dependencies are `npm` modules `bigint-conversion`, `object-sha` and `rsa-module`, which can be installed with the following console commands:

```console
npm install bigint-conversion
npm install object-sha
npm install ../rsa-module
```

**Endpoints:**

- rsaRoutes
  - GET getAPIUsage ( / ): Returns a string with all necessary information for using the rest of endpoints of the service
  - GET getPubKey ( /getPubKey ): Returns the server's RSA public key in base64 format
  - POST encrypt ( /encrypt ): Returns a base64-encoded bigint containing the encrypted message given as a body parameter (NOTE: Not for actual usage, use only for testing purposes)
  - POST decrypt ( /decrypt ): Returns a base64-encoded bigint containing the decrypted message given as a body parameter
  - POST sign ( /sign ): Returns a base64-encoded bigint containing the signed message given as a body parameter
  - POST verify ( /verify ): Returns a base64-encoded bigint containing the verified message given as a body parameter (NOTE: Not for actual usage, use only for testing purposes)
- usersRoutes
  - GET getUsers ( / ): Returns a list of all users registered in the database
  - GET getUserByName ( /:nameUser ): Returns the information of a user given its name in the path
  - POST addUser ( / ): Adds a new user to the database given its name (name), password (password) and type (type, regular user or event organizer) (NOTE: Not for actual usage, use only for testing purposes)
  - PUT updateUser ( /:nameUser ): Updates a user's information given in the body of the request
  - DELETE deleteUser ( /:nameUser ): Deletes a user given its name
- eventRoutes
  - GET getEvents ( / ): Returns a list of all events registered in the database
  - GET getEventByName ( /:name ): Returns the information of an event given its name in the path
  - GET getEventsByAdminName ( /admin/:name ): Returns a list of all events whose admin has the name given in the path
  - POST addEvent ( / ): Creates a new event given its admin name (nameUser), its name (name), its venue date (date), and the maximum available spots (numSpots)
  - PUT joinEvent ( /join/:eventName ): Adds a user to an event, meaning that it has reserved a ticket for accessing to it. User must send one (or many in case of inviting other users) SHA digest of its public key (pubKeys) and, inside the path, the name of the event to join
  - PUT leaveEvent ( /leave/:eventName ): Deletes a user from an event, meaning that it has no interest any more in joining it and that its reserved ticket can be used by any other user. User must send its public key in base64 format (pubKey) and its signed digest (signature, in order to authenticate), plus the name of the event to leave as a path parameter
  - PUT leaseEvent ( /lease/:eventName ): Deletes a user from an event and adds an other in its place. User must send all data needed for joining and leaving an event
  - PUT updateEvent ( /:nameEvent ): Updates the information of an existing event without commiting changes on its joined public keys
  - DELETE deleteEvent ( /:nameEvent ): Deletes an event given its name

**Set up:**

Follow these steps in order to set up the server:

- Import all necessary dependencies by typing the console command `npm install`
- Start a MongoDB server in your machine by typing the console command `mongod`
- Start Typescript transpiler in watch mode by typing on a new terminal the console command `npm run ts` (the previous one will be in use by MongoDB)
- Start the server listening for changes with nodemon typing on a new terminal the console command `npm run dev` (the previous one will be in use by the transpiler's listener)

The default configuration starts the server listening at localhost on TCP port `3000`

The API's base URL is localhost:3000/api

## flutter_project_frontend

This folder contains a Flutter client that allows a user to interact with the events assistance management server (project_backend) in a friendly way.

For installing all necessary dependencies, it is enough with typing the following console command:

```console
flutter pub get
```

**Set up:**

Follow these steps in order to set up the client:

- Import all necessary dependencies by typing the console command `flutter pub get`
- Start the Angular client by typing the console command `flutter run`. The console will prompt all available options for launching the app, after choosing, the app will start by itself without need to open any browser or extra application