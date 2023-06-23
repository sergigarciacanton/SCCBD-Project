import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bigint_conversion/flutter_bigint_conversion.dart';
import 'package:flutter_bigint_crypto_utils/flutter_bigint_crypto_utils.dart';
import 'package:flutter_rsa_module/flutter_rsa_module.dart';
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
  /* var message = 'Hello World!';
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

  BigInt num = prime(1024);
  print(num);
  print(num.bitLength);
  print(isProbablyPrime(num, Random.secure()));

  KeyPair keyPair = generateKeyPair(1024);
  print(keyPair);
  print(keyPair.pubKey.e);
  print(keyPair.pubKey.n);
  print(keyPair.privKey.d);
  print(keyPair.privKey.n);

  //ENCRYPT / DECRYPT
  var encrypted = keyPair.pubKey.encrypt(textToBigint('Holahola'));
  print(encrypted);
  var decrypted = keyPair.privKey.decrypt(encrypted);
  print(bigintToText(decrypted));

  //SIGN / VERIFY
  var signed = keyPair.privKey.sign(textToBigint('Holahola'));
  print(signed);
  var verified = keyPair.pubKey.verify(signed);
  print(bigintToText(verified)); */

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
            final themeProvider = Provider.of<ThemeProvider>(context);
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "BookHub",
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
                    splash: "public/logosplash.png",
                    splashIconSize: 500,
                    screenFunction: () async {
                      var storage = LocalStorage('BookHub');
                      await storage.ready;

                      // SharedPreferences _pref =
                      //     await SharedPreferences.getInstance();

                      // if (_pref.getBool("theme") != null) {
                      //   await _pref.setBool("theme", true);
                      // }

                      var token = LocalStorage('BookHub').getItem('token');
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
                    backgroundColor: Colors.blueGrey));
          },
        ),
      );
}
