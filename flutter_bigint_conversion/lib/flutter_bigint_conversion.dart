library flutter_bigint_conversion;

import 'dart:convert';
export 'flutter_bigint_conversion.dart' hide parseHex;

String parseHex(String a, {bool prefix0x = false, int? byteLength}) {
  RegExp hexPattern = RegExp(r'^(0x)?([\da-fA-F]+)$');
  Match? hexMatch = hexPattern.firstMatch(a);

  if (hexMatch == null) {
    throw RangeError(
        'input must be a hexadecimal string, e.g. \'0x124fe3a\' or \'0214f1b2\'');
  }

  String hex = hexMatch.group(2)!;

  if (byteLength != null) {
    if (byteLength < hex.length ~/ 2) {
      throw RangeError(
          'expected byte length $byteLength < input hex byte length ${hex.length ~/ 2}');
    }
    hex = hex.padLeft(byteLength * 2, '0');
  }

  return prefix0x ? '0x$hex' : hex;
}

List<String> textToBuf(String text) {
  var encoded = utf8.encode(text);
  var buf = <String>[];
  for (var item in encoded) {
    buf.add(item.toRadixString(16));
  }
  return buf;
}

String bufToText(List<String> buf) {
  var codes = <int>[];
  for (var item in buf) {
    codes.add(int.parse(item, radix: 16));
  }
  var decoded = utf8.decode(codes);
  return decoded;
}

String bufToHex(List<String> buf) {
  var hex = '';
  for (var i = 0; i < buf.length; i++) {
    hex = hex + buf[i];
  }
  return hex;
}

List<String> hexToBuf(String hex) {
  hex = parseHex(hex);
  hex = parseHex(hex, prefix0x: false, byteLength: (hex.length / 2).ceil());
  var buf = <String>[];
  int i = 0;
  while (i < hex.length - 1) {
    buf.add(hex[i] + hex[i + 1]);
    i += 2;
  }
  if (i == hex.length - 1) {
    buf.add(hex[i]);
  }
  return buf;
}

BigInt hexToBigint(String hex) {
  var big = BigInt.parse(parseHex(hex, prefix0x: true));
  return big;
}

String bigintToHex(BigInt big) {
  var hex = big.toRadixString(16);
  return hex;
}

String bufToBase64(List<String> hexChars) {
  List<int> bytes = hexChars.map((hex) => int.parse(hex, radix: 16)).toList();
  return base64.encode(bytes);
}

List<String> base64ToBuf(String encoded) {
  var decoded = base64.decode(encoded);
  var buf = <String>[];
  for (var item in decoded) {
    buf.add(item.toRadixString(16));
  }
  for (var i = 0; i < buf.length; i++) {
    if (buf[i].length == 1) {
      buf[i] = '0' + buf[i];
    }
  }
  return buf;
}

BigInt textToBigint(String text) {
  return hexToBigint(bufToHex(textToBuf(text)));
}

String bigintToText(BigInt big) {
  return bufToText(hexToBuf(bigintToHex(big)));
}

String bigintToBase64(BigInt big) {
  return bufToBase64(hexToBuf(bigintToHex(big)));
}

BigInt base64ToBigint(String b64) {
  return hexToBigint(bufToHex(base64ToBuf(b64)));
}

String textToBase64(String text) {
  return bufToBase64(textToBuf(text));
}

String base64ToText(String b64) {
  return bufToText(base64ToBuf(b64));
}
