import * as myModule from "./index";
import * as bcu from "bigint-crypto-utils";

async function shamirTest() {
  const bitLength: number = 2048;
  const outKeys: number = 5;
  const threshold: number = 3;
  const p: bigint = await bcu.prime(bitLength);
  console.log(p);
  const secret = bcu.randBetween(p);
  const sx: myModule.ShamirShare[] = await myModule.generateShares(
    secret,
    threshold,
    outKeys,
    p
  );

  let sx2 = [sx[0], sx[1], sx[3]];

  let s = myModule.getSecret(sx2, p);

  console.log("verified: ", s === secret);

  sx[3].y += 3n;
  sx2 = [sx[0], sx[1], sx[3]];

  s = myModule.getSecret(sx2, p);

  console.log("verified: ", s === secret);
}
shamirTest();
