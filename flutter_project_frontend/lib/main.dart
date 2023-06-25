import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_project_frontend/views/provider/theme_provider.dart';
import 'package:flutter_project_frontend/views/home_scaffold.dart';
import 'package:flutter_project_frontend/views/login_page.dart';
import 'package:flutter_project_frontend/routes/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp() : super();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (context, ThemeProvider notifier, child) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "SCCBD",
                theme: notifier.isDarkMode
                    ? MyThemes.darkTheme
                    : MyThemes.lightTheme,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale!.languageCode &&
                        supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                home: AnimatedSplashScreen.withScreenFunction(
                    duration: 500,
                    splash: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Logo_UPC.svg/1200px-Logo_UPC.svg.png"),
                    splashIconSize: 500,
                    screenFunction: () async {
                      var storage = LocalStorage('SCCBD');
                      await storage.ready;

                      // SharedPreferences _pref =
                      //     await SharedPreferences.getInstance();

                      // if (_pref.getBool("theme") != null) {
                      //   await _pref.setBool("theme", true);
                      // }

                      var token = LocalStorage('SCCBD').getItem('token');
                      if (token == null) {
                        return const LoginPage();
                      }
                      var response = await AuthService.verifyToken(token);
                      if (response == '200') {
                        return const HomeScaffold();
                      }
                      return const LoginPage();
                    },
                    splashTransition: SplashTransition.fadeTransition,
                    pageTransitionType: PageTransitionType.fade,
                    backgroundColor: Colors.grey.shade100));
          },
        ),
      );
}
