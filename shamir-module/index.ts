import * as bcu from "bigint-crypto-utils";
import * as bc from "bigint-conversion";

export class ShamirShare {
  x: number;
  y: bigint;
  p: bigint;

  constructor(x: number, y: bigint, p: bigint) {
    this.x = x;
    this.y = y;
    this.p = p;
  }

  toString(): string {
    return '{"x":"' + this.x + ',"y":"' + this.y + '"}';
  }

  toJSON(): ShamirJsonShare {
    return {
      x: this.x.toString(),
      y: bc.bigintToBase64(this.y),
      p: bc.bigintToBase64(this.p),
    };
  }

  static fromJSON(shamirShare: ShamirJsonShare): ShamirShare {
    const x = parseInt(shamirShare.x);
    const y = bc.base64ToBigint(shamirShare.y);
    const p = bc.base64ToBigint(shamirShare.p);
    return new ShamirShare(x, y, p);
  }
}

export interface ShamirJsonShare {
  x: string; // decimal (base10)
  y: string; // base64
  p: string; // base64
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

export async function generateShares(
  secret: bigint,
  threshold: number,
  numOutShares: number,
  p: bigint
): Promise<Array<ShamirShare>> {
  let a: bigint[] = [secret];
  let i: number = 1;
  while (i < threshold) {
    a.push(bcu.randBetween(p));
    i++;
  }
  let shares: ShamirShare[] = [];
  let x: number = 1;
  while (x <= numOutShares) {
    let y: bigint = 0n;
    let j = 0;
    while (j < threshold) {
      y = (y + ((a[j] * bcu.modPow(x, j, p)) % p)) % p;
      j++;
    }
    shares.push(new ShamirShare(x, y, p));
    x++;
  }
  return shares;
}

export function getSecret(shares: ShamirShare[], p: bigint): bigint {
  let i: number = 0;
  let s: bigint = 0n;
  while (i < shares.length) {
    let sx: bigint = shares[i].y;
    let j: number = 0;
    while (j < shares.length) {
      if (i != j) {
        sx =
          (sx *
            BigInt(shares[j].x) *
            bcu.modInv(shares[j].x - shares[i].x, p)) %
          p;
      }
      j++;
    }
    s = (s + sx) % p;
    i++;
  }
  return bcu.toZn(s, p);
}
