library flutter_rsa_module;

import 'package:flutter_bigint_conversion/flutter_bigint_conversion.dart' as bc;
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

  RsaJsonPubKey toJSON() {
    return RsaJsonPubKey(bc.bigintToBase64(e), bc.bigintToBase64(n));
  }

  static RsaPubKey fromJSON(RsaJsonPubKey rsaJsonPubKey) {
    var e = bc.base64ToBigint(rsaJsonPubKey.e);
    var n = bc.base64ToBigint(rsaJsonPubKey.n);
    return RsaPubKey(e, n);
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

  RsaJsonPrivKey toJSON() {
    return RsaJsonPrivKey(bc.bigintToBase64(d), bc.bigintToBase64(n));
  }

  static RsaPrivKey fromJSON(RsaJsonPrivKey rsaJsonPubKey) {
    var d = bc.base64ToBigint(rsaJsonPubKey.d);
    var n = bc.base64ToBigint(rsaJsonPubKey.n);
    return RsaPrivKey(d, n);
  }
}

class KeyPair {
  final RsaPubKey pubKey;
  final RsaPrivKey privKey;

  KeyPair(this.pubKey, this.privKey);
}

class RsaJsonPubKey {
  String e; // base64
  String n; // base64

  RsaJsonPubKey(this.e, this.n);
}

class RsaJsonPrivKey {
  String d; // base64
  String n; // base64

  RsaJsonPrivKey(this.d, this.n);
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
