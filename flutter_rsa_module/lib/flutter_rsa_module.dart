library flutter_rsa_module;

import 'package:flutter_bigint_crypto_utils/flutter_bigint_crypto_utils.dart';
export 'flutter_rsa_module.dart';

class RsaPubKey {
  BigInt n;
  BigInt e;

  RsaPubKey(this.e, this.n);

  BigInt encrypt(BigInt m) {
    return m.modPow(e, n);
  }

  BigInt verify(BigInt s) {
    return s.modPow(e, n);
  }
}

class RsaPrivKey {
  BigInt n;
  BigInt d;

  RsaPrivKey(this.d, this.n);

  BigInt decrypt(BigInt c) {
    return c.modPow(d, n);
  }

  BigInt sign(BigInt m) {
    return m.modPow(d, n);
  }
}

class KeyPair {
  final RsaPubKey pubKey;
  final RsaPrivKey privKey;

  KeyPair(this.pubKey, this.privKey);
}

KeyPair generateKeyPair(int bitLength) {
  final e = BigInt.from(65537);
  BigInt p;
  BigInt q;
  BigInt phi;
  BigInt n;

  do {
    p = prime((bitLength / 2).floor());
    q = prime((bitLength / 2).ceil() + 1);
    phi = (p - BigInt.one) * (q - BigInt.one);
    n = p * q;
  } while (phi.gcd(e) != BigInt.one || n.bitLength != bitLength);

  final d = e.modInverse(phi);

  return KeyPair(RsaPubKey(e, n), RsaPrivKey(d, n));
}
