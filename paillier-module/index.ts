import * as paillierBigint from "paillier-bigint";
import * as bc from "bigint-conversion";

export class PaillierPubKey {
  key: paillierBigint.PublicKey;

  constructor(key: paillierBigint.PublicKey) {
    this.key = key;
  }

  encrypt(m: bigint): bigint {
    return this.key.encrypt(m);
  }

  add(c1: bigint, c2: bigint) {
    return this.key.addition(c1, c2);
  }

  multiply(c1: bigint, c2: bigint) {
    return this.key.multiply(c1, c2);
  }

  toString(): string {
    return '{"g":"' + this.key.g + '","n":"' + this.key.n + '"}';
  }

  toJSON(): PaillierJsonPubKey {
    return {
      g: bc.bigintToBase64(this.key.g),
      n: bc.bigintToBase64(this.key.n),
    };
  }

  static fromJSON(paillierJsonPubKey: PaillierJsonPubKey): PaillierPubKey {
    const g = bc.base64ToBigint(paillierJsonPubKey.g);
    const n = bc.base64ToBigint(paillierJsonPubKey.n);
    return new PaillierPubKey(new paillierBigint.PublicKey(n, g));
  }
}

export class PaillierPrivKey {
  key: paillierBigint.PrivateKey;

  constructor(key: paillierBigint.PrivateKey) {
    this.key = key;
  }

  decrypt(c: bigint): bigint {
    return this.key.decrypt(c);
  }

  toString(): string {
    return '{"lambda":"' + this.key.lambda + '","mu":"' + this.key.mu + '"}';
  }
}

export interface KeyPair {
  pubKey: PaillierPubKey;
  privKey: PaillierPrivKey;
}

export interface PaillierJsonPubKey {
  g: string; // base64
  n: string; // base64
}

export class JsonMessage {
  data: string; // base64

  constructor(data: string) {
    this.data = data;
  }

  static toJSON(msg: bigint): JsonMessage {
    return {
      data: bc.bigintToBase64(msg),
    };
  }

  static fromJSON(jsonMessage: JsonMessage): bigint {
    return bc.base64ToBigint(jsonMessage.data);
  }
}

export async function generateKeyPair(bitLength: number): Promise<KeyPair> {
  const keys: paillierBigint.KeyPair = await paillierBigint.generateRandomKeys(
    bitLength
  );
  return {
    pubKey: new PaillierPubKey(keys.publicKey),
    privKey: new PaillierPrivKey(keys.privateKey),
  };
}
