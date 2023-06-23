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
  late String idUser;
  late String _locale;
  var storage;

  late String eventName;
  late String idEvent;
  List<dynamic> usersController = List.empty(growable: true);
  TextEditingController controllerPost = TextEditingController(text: '');
  TextEditingController controllerPostTitle = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    fetchEvent();
    getEvent();
  }

  Future<void> getEvent() async {
    Event event = await EventService.getEvent(widget.elementId!);
    eventName = event.name;
  }

  //GET ELEMENTID WITH widget.elementId;
  Future<Event> fetchEvent() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    idUser = LocalStorage('BookHub').getItem('userId');
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
                floatingActionButton: (snapshot.data!.admin.id == idUser)
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
                          log('editEvent');
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

  Widget _buildAdmin(AsyncSnapshot<Event> snapshot) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: BorderRadius.circular(4.0)),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text("Admin: ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                      )),
                  Text(snapshot.data?.admin.name,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                      )),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Image(
                height: 40,
                width: 40,
                image: NetworkImage(snapshot.data?.admin.photoURL),
              )
            ],
          ),
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserView(
                          elementId: snapshot.data?.admin.id,
                          isAuthor: false,
                          setMainComponent: widget.setMainComponent,
                        )))
          },
        ));
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

  Widget _buildCategory(BuildContext context, String category) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildUser(String userName, String mail, String imageURL, String id) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.all(10),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        imageURL,
                        //image.transform().generate()!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text('    ' + userName),
                      Text('    (' + mail + ')'),
                    ],
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserView(
                              elementId: id,
                              isAuthor: false,
                              setMainComponent: widget.setMainComponent,
                            )));
              },
            )));
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
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
    return Row(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
        child: Row(
          children: <Widget>[
            (snapshot.data!.admin.id != idUser)
                ? const SizedBox(width: 60.0)
                : Container(),
            (snapshot.data!.admin.id != idUser)
                ? Expanded(
                    child: InkWell(
                      onTap: () => leaveEvent(),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: Colors.redAccent,
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "leave",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () => joinEvent(),
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(), color: Colors.greenAccent),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Join",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  AsyncSnapshot<Event> snapshot;
  String profileImage_url;
  MySliverAppBar(
      {required this.snapshot,
      required this.expandedHeight,
      required this.profileImage_url});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width < 11000) {
      screenSize = screenSize / 5 * 4;
    }
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              snapshot.data!.name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: screenSize.width / 1.5,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(profileImage_url),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).backgroundColor, width: 3),
              ),
              child: SizedBox(
                height: expandedHeight,
                width: screenSize.width / 4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
