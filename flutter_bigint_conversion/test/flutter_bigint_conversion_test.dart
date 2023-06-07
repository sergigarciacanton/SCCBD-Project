import 'package:flutter_bigint_conversion/flutter_bigint_conversion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var message = 'Hello World!';
  print(message);
  var big = textToBigint(message);
  var hex = bigintToHex(big);
  print(hex);
  var buf = hexToBuf(hex);
  print(buf);
  var b64 = bufToBase64(buf);
  print(b64);
  var buf2 = base64ToBuf(b64);
  print(buf2);
  var hex2 = bufToHex(buf2);
  print(hex2);
  var big2 = hexToBigint(hex2);
  print(big2);
  var message2 = bigintToText(big2);
  print(message2);
  test('conversions', () {
    expect(message2 == message, true);
    expect(big2 == big, true);
    expect(hex2 == hex, true);
  });
}
