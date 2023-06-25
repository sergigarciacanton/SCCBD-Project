import * as myModule from "./index";
import * as bc from "bigint-conversion";
import * as bcu from "bigint-crypto-utils";
import * as objectSha from "object-sha";

async function main() {
  const keys: myModule.KeyPair = await myModule.generateKeyPair(1024);
  /* 
  console.log("TESTING ENCRYPT / DECRYPT");
  const plaintext: string = "1234567890";
  console.log(`Plaintext: ${plaintext}`);

  const ciphertext: bigint = keys.pubKey.encrypt(bc.textToBigint(plaintext));
  console.log("Ciphertext: " + ciphertext);

  const decrypted = bc.bigintToText(keys.privKey.decrypt(ciphertext));
  console.log("Decrypted: " + decrypted);

  if (plaintext === decrypted) {
    console.log("Proof of Correctness: OK");
  } else {
    console.error("Proof of Correctness: FAILED");
  }

  console.log("TESTING ENCRYPT / DECRYPT WITH TRANSFER OBJECTS");
  let message = "1234567890";
  let big = bc.textToBigint(message);
  console.log(big);
  const enc = keys.pubKey.encrypt(big);
  console.log(enc);
  const json = myModule.JsonMessage.toJSON(enc);
  console.log(json);
  const server = myModule.JsonMessage.fromJSON(json);
  const dec = keys.privKey.decrypt(server);
  console.log(dec);
  const res = bc.bigintToText(dec);
  console.log(res);

  console.log("TESTING BLIND SIGNATURES");
  message = "1234567890";
  big = bc.textToBigint(message);
  console.log(big);
  const r = await bcu.prime(Math.floor(2048) / 2);
  console.log(r);
  console.log(bcu.bitLength(big * r));
  console.log(bcu.gcd(r, 2048));
  const bm = bcu.modPow(
    big * bcu.modPow(r, keys.pubKey.e, keys.pubKey.n),
    1,
    keys.pubKey.n
  );
  console.log(bm);
  const sm = bcu.modPow(bm, keys.privKey.d, keys.privKey.n);
  console.log(sm);
  const um = bcu.modPow(sm * bcu.modInv(r, keys.pubKey.n), 1, keys.pubKey.n);
  console.log(um);
  const m2 = bcu.modPow(um, keys.pubKey.e, keys.privKey.n);
  console.log(bc.bigintToText(m2)); */
  const jsonPubKey = keys.pubKey.toJSON();
  console.log("JSON pubKey");
  console.log(jsonPubKey);
  console.log(JSON.stringify(jsonPubKey));
  const stringPubKey = await objectSha.digest(JSON.stringify(jsonPubKey));
  console.log("String pubKey's hash");
  console.log(stringPubKey);
  const bigintPubKey = bc.textToBigint(stringPubKey);
  // console.log("Bigint");
  // console.log(bigintPubKey);
  const signedPubKey = keys.privKey.sign(bigintPubKey);
  // console.log("Signed");
  // console.log(signedPubKey);
  const signedBase64PubKey = myModule.JsonMessage.toJSON(signedPubKey);
  console.log("Signed Base64 pubKey's hash");
  console.log(signedBase64PubKey);
  const signed2PubKey = myModule.JsonMessage.fromJSON(signedBase64PubKey);
  /* console.log("Signed2");
  console.log(signed2PubKey);
  console.log(signedPubKey == signed2PubKey);
  const verifiedPubKey = keys.pubKey.verify(signedPubKey);
  console.log("Verified");
  console.log(verifiedPubKey);
  console.log(bigintPubKey == verifiedPubKey);
  const string2PubKey = bc.bigintToText(verifiedPubKey);
  console.log("String2");
  console.log(string2PubKey);
  console.log(stringPubKey == string2PubKey);
  console.log("Base64"); */
}

main();
