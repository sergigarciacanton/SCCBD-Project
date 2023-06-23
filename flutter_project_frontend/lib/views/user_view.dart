import 'dart:developer';
import 'package:flutter_project_frontend/routes/user_service.dart';
import 'package:flutter_project_frontend/views/event_page.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class UserView extends StatefulWidget {
  final Function? setMainComponent;
  final String? elementId;
  final bool? isAuthor;
  const UserView({
    Key? key,
    this.elementId,
    this.isAuthor,
    this.setMainComponent,
  }) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  var user;
  var currentUser;
  var titleText;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<dynamic> fetchUser() async {
    currentUser = await UserService.getUserByUserName(
        LocalStorage('BookHub').getItem('userName'));
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(titleText),
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
                    Navigator.of(context).pop();
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
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context).shadowColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        snapshot.data!.photoURL as String))),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35, left: 20),
                      child: RichText(
                          text: TextSpan(
                              text: 'name: ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                              children: <TextSpan>[
                            TextSpan(
                                text: snapshot.data!.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal))
                          ])),
                    ),
                    (user != null)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 15, left: 20),
                            child: RichText(
                                text: TextSpan(
                                    text: "mail: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text: snapshot.data!.mail,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal))
                                ])),
                          )
                        : Container(),
                    (user != null)
                        ? Column(children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  'clubs',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 20, bottom: 15),
                                child: Text(
                                  'events',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: eventList(snapshot),
                                )),
                          ])
                        : Container(),
                    SizedBox(
                      height: 20,
                    )
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

  List<Widget> eventList(AsyncSnapshot<dynamic> snapshot) {
    List<Widget> list = [];
    snapshot.data!.events.forEach((element) {
      list.add(Container(
          width: 300,
          height: 150,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(15),
            elevation: 10,
            child: Column(children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                title: Text(element.name),
                subtitle: Text(
                    "participants: " + element.usersList.length.toString()),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                    ),
                    ElevatedButton(
                        child: Text('more'),
                        onPressed: () => {
                              Navigator.of(context).pop(),
                              widget.setMainComponent!(EventPage(
                                elementId: element.id,
                                setMainComponent: widget.setMainComponent,
                              ))
                            })
                  ]),
            ]),
          )));
    });
    return list;
  }
}
