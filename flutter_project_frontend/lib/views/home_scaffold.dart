import 'package:flutter/material.dart';
import 'package:flutter_project_frontend/views/mobile_layout.dart';
import 'package:flutter_project_frontend/views/web_layout.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1100) {
          return Container(
            child: MobileLayout(),
            height: constraints.maxHeight,
            width: constraints.maxWidth,
          );
        } else {
          return Container(
            child: WebLayout(),
            height: constraints.maxHeight,
            width: constraints.maxWidth,
          );
        }
      },
    );
  }
}
