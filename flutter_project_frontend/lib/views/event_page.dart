import 'dart:convert';
import 'dart:developer';

import 'package:flutter_project_frontend/models/event.dart';
import 'package:flutter_project_frontend/routes/event_service.dart';
import 'package:flutter_project_frontend/views/widgets/new_event.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_bigint_conversion/flutter_bigint_conversion.dart';
import 'package:flutter_rsa_module/flutter_rsa_module.dart';
import 'package:crypto/crypto.dart';

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
    storage = LocalStorage('SCCBD');
    await storage.ready;

    userName = LocalStorage('SCCBD').getItem('userName');
    Event event = await EventService.getEvent(widget.elementId!);
    eventName = event.name;
    return event;
  }

  Future<void> leaveEvent(RsaJsonPubKey pubKey, String signature) async {
    await EventService.leaveEvent(widget.elementId!, pubKey, signature);
    setState(() {});
  }

  Future<void> joinEvent(List<String> pubKeys) async {
    await EventService.joinEvent(widget.elementId!, pubKeys);
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
        _buildAvailableSpots(context, snapshot),
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

  Widget _buildAvailableSpots(
      BuildContext context, AsyncSnapshot<Event> snapshot) {
    TextStyle bioTextStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        snapshot.data!.availableSpots.toString(),
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
                          String storedPubKeyJson =
                              storage.getItem(eventName + '_pub');
                          String storedPrivKeyJson =
                              storage.getItem(eventName + '_priv');

                          // Convert the JSON string back to a map of BigInts
                          Map<String, BigInt> storedPubKeyMap =
                              (jsonDecode(storedPubKeyJson)
                                      as Map<String, dynamic>)
                                  .map((k, v) => MapEntry(k, BigInt.parse(v)));
                          Map<String, BigInt> storedPrivKeyMap =
                              (jsonDecode(storedPrivKeyJson)
                                      as Map<String, dynamic>)
                                  .map((k, v) => MapEntry(k, BigInt.parse(v)));

                          String pubKeyJson =
                              jsonEncode(storedPubKeyJson).replaceAll("\\", "");

                          BigInt storedPubKeyE = storedPubKeyMap['e']!;
                          BigInt storedPubKeyN = storedPubKeyMap['n']!;
                          BigInt storedPrivKeyD = storedPrivKeyMap['d']!;

                          KeyPair storedKeyPair;
                          // Convert the map of BigInts back to a KeyPair
                          storedKeyPair = KeyPair(
                              RsaPubKey(storedPubKeyE, storedPubKeyN),
                              RsaPrivKey(storedPrivKeyD, storedPubKeyN));
                          var encoded = utf8.encode(pubKeyJson);
                          List<int> copy = List.from(encoded);
                          copy.removeAt(0);
                          copy.removeLast();
                          print(pubKeyJson.toString());
                          print(copy);
                          leaveEvent(
                              storedKeyPair.pubKey.toJSON(),
                              bigintToBase64(storedKeyPair.privKey.sign(
                                  textToBigint(
                                      sha256.convert(copy).toString()))));
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
                      KeyPair keyPair = generateKeyPair(1024);
                      Map<String, String> pubKeyMap = {
                        'e': keyPair.pubKey.e.toString(),
                        'n': keyPair.pubKey.n.toString()
                      };
                      Map<String, String> privKeyMap = {
                        'd': keyPair.privKey.d.toString(),
                        'n': keyPair.privKey.n.toString()
                      };
                      storage.setItem(
                          eventName + '_pub', jsonEncode(pubKeyMap));
                      storage.setItem(
                          eventName + '_priv', jsonEncode(privKeyMap));
                      String pubKeyJson = jsonEncode(pubKeyMap);
                      joinEvent(
                          [sha256.convert(utf8.encode(pubKeyJson)).toString()]);
                    }),
                constraints: const BoxConstraints(maxWidth: 200))
          ],
        ),
      )
    ]);
  }
}
