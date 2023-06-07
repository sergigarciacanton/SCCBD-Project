library flutter_bigint_crypto_utils;

import 'dart:math';
import 'package:flutter_bigint_conversion/flutter_bigint_conversion.dart';
export 'flutter_bigint_crypto_utils.dart' show prime, isProbablyPrime;

BigInt prime(int bitLength) {
  final random = Random.secure();
  final generator = Random();

  while (true) {
    BigInt candidate = _generateRandomBigInt(bitLength, random);
    candidate = candidate.toUnsigned(bitLength);
    if (candidate.bitLength == bitLength) {
      final nextPrime = findNextPrime(candidate, generator);
      if (nextPrime != null) {
        return nextPrime;
      }
    }
  }
}

BigInt _generateRandomBigInt(int bitLength, Random random) {
  final bytesNeeded = (bitLength + 7) ~/
      8; // Number of bytes needed to represent the bit length
  final values = List<int>.generate(
      bytesNeeded, (_) => random.nextInt(256)); // Generate random bytes

  return hexToBigint(bufToHex(values.map((el) => el.toString()).toList()));
}

BigInt? findNextPrime(BigInt n, Random generator) {
  if (n.isEven) {
    n += BigInt.one;
  } else {
    n += BigInt.from(2);
  }

  while (true) {
    if (isProbablyPrime(n, generator)) {
      return n;
    }
    n += BigInt.from(2); // Skip even numbers
  }
}

bool isProbablyPrime(BigInt n, Random random) {
  if (n == BigInt.two || n == BigInt.from(3)) {
    return true;
  }
  if (n < BigInt.two || n.isEven) {
    return false;
  }

  const iterations = 5;
  for (var i = 0; i < iterations; i++) {
    final a = BigInt.from(2) + _randomBigIntLessThan(n - BigInt.two, random);
    if (!millerRabinTest(n, a)) {
      return false;
    }
  }
  return true;
}

BigInt _randomBigIntLessThan(BigInt max, Random random) {
  final candidate = _generateRandomBigInt(max.bitLength, random);
  return candidate < max ? candidate : candidate % max;
}

bool millerRabinTest(BigInt n, BigInt a) {
  final s = n - BigInt.one;
  var d = s;
  var r = 0;

  while (d.isEven) {
    d >>= 1;
    r++;
  }

  var x = a.modPow(d, n);
  if (x == BigInt.one || x == s) {
    return true;
  }

  for (var _ = 0; _ < r - 1; _++) {
    x = x.modPow(BigInt.two, n);
    if (x == s) {
      return true;
    }
    if (x == BigInt.one) {
      return false;
    }
  }

  return false;
}
