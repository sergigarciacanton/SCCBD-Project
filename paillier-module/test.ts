import * as myModule from "./index";

async function paillierTest() {
  const { pubKey, privKey } = await myModule.generateKeyPair(3072);

  const m1: bigint = 1234567890n;
  const m2: bigint = 1n;
  console.log("First message: " + m1);
  console.log("Second message: " + m2);

  const c1: bigint = pubKey.encrypt(m1);
  console.log(
    "Encryption + decryption result for first message: " + privKey.decrypt(c1)
  );

  const c2: bigint = pubKey.encrypt(m2);
  const encryptedSum: bigint = pubKey.add(c1, c2);
  console.log(
    "Decrypted result of encrypted sum: " + privKey.decrypt(encryptedSum)
  );

  const k: bigint = 2n;
  const encryptedMul: bigint = pubKey.multiply(c1, k);
  console.log(
    "Decrypted result of encrypted multiplication by " +
      k +
      ": " +
      privKey.decrypt(encryptedMul)
  );

  const num = "1234567890";
  const text = BigInt(num);
  console.log(text);
}
paillierTest();
