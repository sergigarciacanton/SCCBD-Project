import 'package:flutter_project_frontend/routes/user_service.dart';
import 'package:flutter_project_frontend/views/home_scaffold.dart';
import 'package:flutter_project_frontend/views/login_page.dart';
import 'package:flutter_project_frontend/views/settings/account_page.dart';
import 'package:flutter_project_frontend/views/widgets/edit_profile.dart';
import 'package:flutter_project_frontend/views/widgets/icon_widget.dart';
import 'package:flutter_project_frontend/views/widgets/change_theme_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:localstorage/localstorage.dart';

import '../models/user.dart';
import '../routes/user_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _noreports = true;
  String username = "";
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final typeController = TextEditingController(text: "");

  void initState() {
    super.initState();
    fetchUser();
  }

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;
    username = LocalStorage('BookHub').getItem('userName');
    return UserService.getUserByUserName(username);
  }

  TextEditingController controllerOld = TextEditingController(text: '');
  TextEditingController controllerNew = TextEditingController(text: '');
  TextEditingController controllerCheck = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
              child: ListView(padding: EdgeInsets.all(24), children: [
        Text(
          'Settings',
          style: const TextStyle(
            fontSize: 40,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        SettingsGroup(
          title: 'GENERAL ',
          children: <Widget>[
            buildAccountTheme(context),
            AccountPage(),
            buildEditProfile(),
            buildLogout(),
            buildPassword(),
            buildDeleteAccount(),
          ],
        ),
      ])));

  Widget buildEditProfile() => SimpleSettingsTile(
        title: 'View profile',
        subtitle: '',
        leading: const IconWidget(icon: Icons.face, color: Colors.orange),
        child: EditProfile(),
      );
  Widget buildLogout() => SimpleSettingsTile(
      title: 'Log out',
      subtitle: '',
      leading: const IconWidget(icon: Icons.logout, color: Colors.blueAccent),
      onTap: () => {
            LocalStorage('BookHub').deleteItem('token'),
            Navigator.pop(context),
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()))
          });

  Widget buildPassword() => SimpleSettingsTile(
      title: 'Change password',
      subtitle: '',
      leading: const IconWidget(icon: Icons.lock, color: Colors.purpleAccent),
      onTap: () => {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change password',
                            style: TextStyle(fontSize: 20),
                          ),
                          buildEdit('Old password', controllerOld),
                          buildEdit('New password', controllerNew),
                          buildEdit('Repeat password', controllerCheck),
                          ElevatedButton(
                              onPressed: () {
                                if (controllerOld.text.isEmpty &&
                                    controllerNew.text.isEmpty &&
                                    controllerCheck.text.isEmpty) {
                                  print("algun campo vacio");
                                } else {
                                  if (controllerCheck.text ==
                                      controllerNew.text) {
                                    UserService.changePassword(
                                        LocalStorage('BookHub')
                                            .getItem('userId'),
                                        controllerNew.text,
                                        controllerOld.text);
                                    Navigator.of(context).pop();
                                  } else {
                                    print("print psw no coincideixen");
                                  }
                                }
                              },
                              child: Text('Change'))
                        ],
                      ),
                    ),
                  );
                })
          });
  Widget buildEdit(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: TextField(
        obscureText: true,
        controller: controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            hintText: labelText,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            )),
      ),
    );
  }

  Widget buildDeleteAccount() => SimpleSettingsTile(
      title: 'Delete Account',
      subtitle: '',
      leading: const IconWidget(icon: Icons.delete, color: Colors.pink),
      onTap: () async => {
            await UserService.deleteAccount(
                LocalStorage('BookHub').getItem('userId') as String),
            LocalStorage('BookHub').deleteItem('token'),
            Navigator.pop(context),
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()))
          });

  Widget buildAccountTheme(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Tema: "),
          const Spacer(),
          ChangeThemeButtonWidget(),
        ],
      );
}
