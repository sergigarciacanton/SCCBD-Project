import * as myModule from "./index";

async function paillierTest() {
  const { pubKey, privKey } = await myModule.generateKeyPair(3072);

  const m1 = 1234567890n;
  const m2 = 1n;
  console.log("First message: " + m1);
  console.log("Second message: " + m2);

  const c1 = pubKey.encrypt(m1);
  console.log(
    "Encryption + decryption result for first message: " + privKey.decrypt(c1)
  );

  const c2 = pubKey.encrypt(m2);
  const encryptedSum = pubKey.add(c1, c2);
  console.log(
    "Decrypted result of encrypted sum: " + privKey.decrypt(encryptedSum)
  );

  const k = 2n;
  const encryptedMul = pubKey.multiply(c1, k);
  console.log(
    "Decrypted result of encrypted multiplication by " +
      k +
      ": " +
      privKey.decrypt(encryptedMul)
  );
}
paillierTest();
