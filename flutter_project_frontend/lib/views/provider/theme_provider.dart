import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String key = "theme";
  late SharedPreferences _pref;

  bool _darkTheme = false;
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
      scaffoldBackgroundColor: Colors.grey.shade100,
      primaryColor: Colors.black,
      primaryColorLight: const Color.fromARGB(255, 0, 123, 192),
      colorScheme: const ColorScheme.light(),
      iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 123, 192)),
      indicatorColor: Colors.grey.shade100,
      backgroundColor: Color.fromARGB(255, 0, 123, 192),
      shadowColor: const Color.fromARGB(150, 0, 123, 192),
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade200),
      navigationBarTheme:
          NavigationBarThemeData(backgroundColor: Colors.grey.shade200),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(backgroundColor: Colors.grey.shade200),
      hintColor: Color.fromARGB(255, 0, 123, 192),
      toggleButtonsTheme: ToggleButtonsThemeData(color: Colors.grey.shade800),
      textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.black)));

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
