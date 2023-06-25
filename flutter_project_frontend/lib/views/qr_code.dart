import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrCode extends StatelessWidget {
  final Function? setMainComponent;
  final String? data;

  const MyQrCode({
    Key? key,
    this.data,
    this.setMainComponent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            color: Colors.white,
            child: QrImage(
              data: data!,
              version: QrVersions.auto,
              size: 320,
              gapless: false,
            )));
  }
}
