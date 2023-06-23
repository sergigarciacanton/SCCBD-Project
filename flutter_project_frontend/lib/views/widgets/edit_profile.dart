import 'dart:developer';
import 'package:flutter_project_frontend/models/user.dart';
import 'package:flutter_project_frontend/routes/user_service.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../settings_page.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String userName;
  var storage;
  var isEditing = false;
  String biograpy = "";
  TextEditingController _textFieldController = TextEditingController();

  TextEditingController controllerName = TextEditingController(text: 'Name');
  TextEditingController controllerUserName =
      TextEditingController(text: 'userName');
  TextEditingController controllerMail = TextEditingController(text: 'mail');
  TextEditingController controllerBiography =
      TextEditingController(text: 'biography');

  String controllerBirthDay = "";
  String userPhotoURL = "";

  void initState() {
    super.initState();
    fetchUser();
  }

  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    userName = LocalStorage('BookHub').getItem('userName');

    return UserService.getUserByUserName(userName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            controllerName.text = snapshot.data!.name;

            return Scaffold(
              appBar: AppBar(
                foregroundColor: Theme.of(context).primaryColor,
                title: Text(
                  'editProfile',
                ),
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 1,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => const SettingPage());
                    Navigator.pop(context, route);
                  },
                ),
              ),
              body: Container(
                padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    buildData(snapshot),
                    const SizedBox(
                      height: 35,
                    ),
                    (isEditing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    isEditing = false;
                                  });
                                },
                                child: Text('returnToHome',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.black)),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (controllerName.value.text.isNotEmpty) {
                                    var response = await UserService.updateUser(
                                        userName, 0);

                                    if (response) {
                                      setState(() {
                                        isEditing = false;
                                      });
                                    }
                                  } else {
                                    String error = "Se ha producido un error";
                                    controllerName.text.isEmpty
                                        ? error = "Name empty"
                                        : null;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(error),
                                        );
                                      },
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                ),
                                child: Text(
                                  'accept',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          )
                        : Container(
                            height: 10,
                          )),
                    SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            print(snapshot.error);
            //   throw snapshot.error.hashCode;
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).backgroundColor,
            ),
          );
        });
  }

  Widget buildData(AsyncSnapshot<User> snapshot) {
    return Column(
      children: [
        buildEdit('name', controllerName),
      ],
    );
  }

  Widget buildEdit(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        onTap: () {
          (!isEditing)
              ? setState(() {
                  isEditing = true;
                })
              : null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: labelText,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            )),
      ),
    );
  }

  Widget buildEditBig(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controller,
        maxLines: 10,
        maxLength: 1000,
        strutStyle: StrutStyle(),
        onTap: () {
          (!isEditing)
              ? setState(() {
                  isEditing = true;
                })
              : null;
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: labelText,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            )),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      height: 2.0,
      color: Colors.black54,
      margin: const EdgeInsets.only(top: 6, bottom: 6),
    );
  }

  Widget _buildSeparatorBig() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: 2.0,
      color: Colors.black54,
      margin: const EdgeInsets.only(top: 6, bottom: 6),
    );
  }
}
