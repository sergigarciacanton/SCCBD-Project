import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String key = "theme";
  late SharedPreferences _pref;

  bool _darkTheme = true;
  bool get isDarkMode => _darkTheme;

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  ThemeProvider() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  _initPrefs() async {
    _pref = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _pref.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _pref.setBool(key, _darkTheme);
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade900,
      primaryColor: Colors.black,
      primaryColorLight: const Color.fromARGB(181, 255, 153, 0),
      colorScheme: const ColorScheme.dark(),
      iconTheme: IconThemeData(color: Colors.orange.shade500),
      indicatorColor: Colors.teal,
      backgroundColor: Colors.orange.shade500,
      shadowColor: const Color.fromARGB(143, 255, 153, 0),
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade800),
      navigationBarTheme:
          NavigationBarThemeData(backgroundColor: Colors.grey.shade800),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(backgroundColor: Colors.grey.shade800),
      hintColor: Colors.orange,
      toggleButtonsTheme: ToggleButtonsThemeData(color: Colors.grey.shade800),
      textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)));

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.red.shade50,
      primaryColor: Colors.white,
      primaryColorLight: const Color.fromARGB(153, 251, 146, 42),
      colorScheme: const ColorScheme.light(),
      iconTheme: const IconThemeData(color: Colors.red),
      indicatorColor: Colors.pinkAccent,
      backgroundColor: Colors.red,
      shadowColor: const Color.fromARGB(153, 251, 202, 42),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.red),
      navigationBarTheme:
          const NavigationBarThemeData(backgroundColor: Colors.red),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(backgroundColor: Colors.grey.shade800),
      hintColor: Colors.red,
      toggleButtonsTheme: ToggleButtonsThemeData(color: Colors.red.shade100),
      textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.black)));
}
