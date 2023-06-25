import 'package:flutter_project_frontend/models/login.dart';
import 'package:flutter_project_frontend/routes/auth_service.dart';
import 'package:flutter_project_frontend/views/home_scaffold.dart';
import 'package:flutter_project_frontend/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool darkTheme = false;

  Future<void> getThemeMode() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      darkTheme = _pref.getBool("theme")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    final LocalStorage storage = LocalStorage('SCCBD');

    return FutureBuilder(
        future: getThemeMode(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
            body: Center(
              child: ListView(
                children: [
                  isLoading
                      ? LinearProgressIndicator(
                          color: Theme.of(context).backgroundColor,
                        )
                      : const SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.25, vertical: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        darkTheme
                            ? Image.asset("public/logowhite.png")
                            : Image.asset("public/logo.png"),
                        const Text(
                          'Sign in',
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 650),
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).backgroundColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).backgroundColor,
                                    width: 3.0),
                              ),
                              hintText: 'Username',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 650),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).backgroundColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).backgroundColor,
                                    width: 3.0),
                              ),
                              hintText: 'Password',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 650),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).backgroundColor),
                              minimumSize: MaterialStateProperty.all(
                                  Size(MediaQuery.of(context).size.width, 60)),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              var response = await authService.login(LoginModel(
                                  name: usernameController.text,
                                  password: passwordController.text));
                              setState(() {
                                isLoading = false;
                              });
                              if (response == "200") {
                                storage.setItem('userName',
                                    usernameController.text.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScaffold()));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(response.toString()),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Still without account?',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
