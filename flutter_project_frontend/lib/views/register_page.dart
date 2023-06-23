import 'package:flutter_project_frontend/models/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_frontend/routes/auth_service.dart';
import 'package:flutter_project_frontend/views/home_scaffold.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  bool isChecked = false;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  String birthDate = "";
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  bool darkTheme = false;

  @override
  void initState() {
    super.initState();
    getThemeMode();
  }

  Future<void> getThemeMode() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      darkTheme = _pref.getBool("theme")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    final LocalStorage storage = LocalStorage('BookHub');

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
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.25, vertical: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  darkTheme
                      ? Image.asset("public/logowhite.png")
                      : Image.asset("public/logo.png"),
                  Text(
                    'register',
                    style: const TextStyle(
                        fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                              width: 2.0),
                        ),
                        hintText: 'name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
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
                        hintText: 'password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: TextField(
                      controller: repeatPasswordController,
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
                        hintText: 'repeatPassword',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Theme.of(context).primaryColor,
                        activeColor: Theme.of(context).backgroundColor,
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Text(
                        'termsAndConditions',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).backgroundColor),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 60)),
                      ),
                      child: Text(
                        'submit',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if (passwordController.text !=
                            repeatPasswordController.text) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text('passwordError'),
                              );
                            },
                          );
                        } else if (!isChecked) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text('termsError'),
                              );
                            },
                          );
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          var response = await authService.register(
                              RegisterModel(
                                  name: nameController.text,
                                  password: passwordController.text,
                                  type: 0));
                          setState(() {
                            isLoading = false;
                          });
                          if (response == "201") {
                            storage.setItem(
                                'userName', usernameController.text.toString());
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
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'alreadyWithAccount',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                          child: Text(
                            'signIn',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
