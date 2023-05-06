import * as bcu from "bigint-crypto-utils";
import * as bc from "bigint-conversion";

export class RsaPubKey {
  e: bigint;
  n: bigint;

  constructor(e: bigint, n: bigint) {
    this.e = e;
    this.n = n;
  }

  encrypt(m: bigint): bigint {
    return bcu.modPow(m, this.e, this.n);
  }

  verify(s: bigint): bigint {
    return bcu.modPow(s, this.e, this.n);
  }

  toString(): string {
    return '{"e":"' + this.e + '","n":"' + this.n + '"}';
  }

  toJSON(): RsaJsonPubKey {
    return {
      e: bc.bigintToBase64(this.e),
      n: bc.bigintToBase64(this.n),
    };
  }

  static fromJSON(rsaJsonPubKey: RsaJsonPubKey): RsaPubKey {
    const e = bc.base64ToBigint(rsaJsonPubKey.e);
    const n = bc.base64ToBigint(rsaJsonPubKey.n);
    return new RsaPubKey(e, n);
  }
}

export class RsaPrivKey {
  d: bigint;
  n: bigint;

  constructor(d: bigint, n: bigint) {
    this.d = d;
    this.n = n;
  }

  decrypt(c: bigint): bigint {
    return bcu.modPow(c, this.d, this.n);
  }

  sign(m: bigint): bigint {
    return bcu.modPow(m, this.d, this.n);
  }

  toString(): string {
    return '{"d":"' + this.d + '","n":"' + this.n + '"}';
  }
}

export interface KeyPair {
  pubKey: RsaPubKey;
  privKey: RsaPrivKey;
}

export interface RsaJsonPubKey {
  e: string; // base64
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
  const e: bigint = 65537n;
  let p: bigint;
  let q: bigint;
  let phi: bigint;
  let n: bigint;
  do {
    p = await bcu.prime(Math.floor(bitLength) / 2);
    q = await bcu.prime(Math.floor(bitLength / 2) + 1);
    phi = (p - 1n) * (q - 1n);
    n = p * q;
  } while (bcu.gcd(e, phi) !== 1n || bcu.bitLength(n) !== bitLength);

  const d = bcu.modInv(e, phi);
  return { pubKey: new RsaPubKey(e, n), privKey: new RsaPrivKey(d, n) };
}
