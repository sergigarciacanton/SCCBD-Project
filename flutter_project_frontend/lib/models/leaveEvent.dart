import 'package:flutter_rsa_module/flutter_rsa_module.dart';

class LeaveEvent {
  RsaJsonPubKey pubKey;
  String signature;

  LeaveEvent({required this.pubKey, required this.signature});

  static Map<String, dynamic> toJson(LeaveEvent values) {
    print(values.pubKey);
    return {
      'pubKey': {'e': values.pubKey.e, 'n': values.pubKey.n},
      'signature': {'data': values.signature}
    };
  }
}
