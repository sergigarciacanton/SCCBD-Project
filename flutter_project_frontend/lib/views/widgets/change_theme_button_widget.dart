import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_frontend/views/provider/theme_provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, notifier, child) => Switch.adaptive(
        onChanged: (value) {
          notifier.toggleTheme();
        },
        value: notifier.isDarkMode,
      ),
    );
  }
}
