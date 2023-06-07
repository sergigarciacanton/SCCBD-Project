import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bigint_crypto_utils/flutter_bigint_crypto_utils.dart';
import 'dart:math';

void main() {
  var bitLength = 1024;
  final primeNum = prime(bitLength);
  print(primeNum);
  test('Prime-generator', () {
    expect(primeNum.bitLength, bitLength);
    expect(isProbablyPrime(primeNum, Random.secure()), true);
  });
}
