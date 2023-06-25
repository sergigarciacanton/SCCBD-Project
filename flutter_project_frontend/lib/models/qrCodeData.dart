import 'package:flutter_rsa_module/flutter_rsa_module.dart';

class QrCodeData {
  String nameEvent;
  RsaJsonPubKey pubKey;
  String signature;

  QrCodeData(
      {required this.nameEvent, required this.pubKey, required this.signature});

  static Map<String, dynamic> toJson(QrCodeData values) {
    return {
      'eventName': values.nameEvent,
      'pubKey': {'e': values.pubKey.e, 'n': values.pubKey.n},
      'signature': {'data': values.signature}
    };
  }

  factory QrCodeData.fromJson(dynamic json) {
    return QrCodeData(
        nameEvent: json['eventName'].toString(),
        pubKey: RsaJsonPubKey(json['pubKey']['e'], json['pubKey']['n']),
        signature: json['signature']['data'].toString());
  }

  @override
  toString() {
    return '{"eventName": "$nameEvent", "pubKey": {"e": "${pubKey.e}", "n": "${pubKey.n}"}, "signature": {"data": "$signature"}}';
  }
}
