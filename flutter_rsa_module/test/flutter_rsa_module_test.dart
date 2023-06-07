import 'package:flutter_bigint_conversion/flutter_bigint_conversion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rsa_module/flutter_rsa_module.dart';

void main() {
  //GENERATE KEY PAIR
  var keyLength = 1024;
  KeyPair keyPair = generateKeyPair(keyLength);
  print(keyPair);
  print(keyPair.pubKey.e);
  print(keyPair.pubKey.n);
  print(keyPair.privKey.d);
  print(keyPair.privKey.n);
  var message = 'Holahola';

  //ENCRYPT / DECRYPT
  var encrypted = keyPair.pubKey.encrypt(textToBigint(message));
  print(encrypted);
  var decrypted = keyPair.privKey.decrypt(encrypted);
  print(bigintToText(decrypted));

  //SIGN / VERIFY
  var signed = keyPair.privKey.sign(textToBigint(message));
  print(signed);
  var verified = keyPair.pubKey.verify(signed);
  print(bigintToText(verified));
  test('Module', () {
    expect(keyPair.pubKey.e, BigInt.from(65537));
    expect(keyPair.pubKey.n.bitLength, keyLength);
    expect(message, bigintToText(decrypted));
    expect(message, bigintToText(verified));
  });
}
