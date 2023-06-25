import 'dart:developer';

import 'package:flutter_project_frontend/models/event.dart';
import 'package:flutter_project_frontend/routes/event_service.dart';
import 'package:flutter_project_frontend/routes/user_service.dart';
import 'package:flutter_project_frontend/views/user_view.dart';
import 'package:flutter_project_frontend/views/widgets/new_event.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class EventPage extends StatefulWidget {
  final Function? setMainComponent;
  final String? elementId;

  const EventPage({
    Key? key,
    this.elementId,
    this.setMainComponent,
  }) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late String userName;
  var storage;

  late String eventName;
  late String idEvent;
  List<dynamic> usersController = List.empty(growable: true);
  TextEditingController controllerPost = TextEditingController(text: '');
  TextEditingController controllerPostTitle = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  //GET ELEMENTID WITH widget.elementId;
  Future<Event> fetchEvent() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    userName = LocalStorage('BookHub').getItem('userName');
    return EventService.getEvent(widget.elementId!);
  }

  Future<void> leaveEvent() async {
    await EventService.leaveEvent(widget.elementId!);
    setState(() {});
  }

  Future<void> joinEvent() async {
    await EventService.joinEvent(widget.elementId!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width < 11000) {
      screenSize = screenSize / 5 * 4;
    }
    return FutureBuilder(
        future: fetchEvent(),
        builder: (context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                floatingActionButton: (snapshot.data!.admin.name == userName)
                    ? FloatingActionButton(
                        backgroundColor: Theme.of(context).iconTheme.color,
                        child: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewEvent(eventId: snapshot.data!.id)),
                          );
                          log('E D I T  E V E N T');
                        },
                      )
                    : null,
                body: Stack(
                  children: <Widget>[
                    SafeArea(
                        child: CustomScrollView(
                      slivers: <Widget>[
                        /* SliverPersistentHeader(
                          delegate: MySliverAppBar(
                              snapshot: snapshot,
                              expandedHeight: 150,
                              profileImage_url: snapshot.data!.photoURL),
                          pinned: true,
                        ), */
                        SliverToBoxAdapter(
                            child: SafeArea(
                          child: SingleChildScrollView(
                              child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 30,
                                  ),
                                  child: IntrinsicHeight(
                                      child: Container(
                                          child: _Event(context, snapshot,
                                              screenSize))))),
                        )),
                      ],
                    ))
                  ],
                ));
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

  Widget _Event(
      BuildContext context, AsyncSnapshot<Event> snapshot, Size screenSize) {
    return Column(
      children: [
        Container(height: 3, color: Theme.of(context).backgroundColor),
        const SizedBox(height: 10),
        Container(
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              SizedBox(
                width: screenSize.width / 1.5,
                child: _buildName(snapshot),
              ),
              Container(
                width: screenSize.width / 3.5,
              )
            ])),
        _buildSeparator(screenSize),
        _buildNumSpots(context, snapshot),
        _buildSeparator(screenSize),
        _buildButtons(snapshot),
      ],
    );
  }

  Widget _buildName(AsyncSnapshot<Event> snapshot) {
    if (snapshot.data!.name == true) {
      eventName = snapshot.data!.name;
    }
    return Text(snapshot.data!.name,
        style: const TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
        ));
  }

  Widget _buildNumSpots(BuildContext context, AsyncSnapshot<Event> snapshot) {
    TextStyle bioTextStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        snapshot.data!.numSpots.toString(),
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: const EdgeInsets.only(top: 6, bottom: 6),
    );
  }

  Widget _buildButtons(AsyncSnapshot<Event> snapshot) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
        child: Row(
          children: <Widget>[
            (snapshot.data!.admin.name != userName)
                ? const SizedBox(width: 60.0)
                : Container(),
            (snapshot.data!.admin.name != userName)
                ? Container(
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).backgroundColor),
                          minimumSize: MaterialStateProperty.all(
                              Size(MediaQuery.of(context).size.width, 60)),
                        ),
                        child: const Text(
                          'Leave',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          leaveEvent();
                        }),
                    constraints: const BoxConstraints(maxWidth: 200))
                : Container(),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Container(
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).backgroundColor),
                      minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 60)),
                    ),
                    child: const Text(
                      'Join',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      joinEvent();
                    }),
                constraints: const BoxConstraints(maxWidth: 200))
          ],
        ),
      )
    ]);
  }
}
