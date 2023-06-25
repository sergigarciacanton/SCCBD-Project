import 'package:flutter_project_frontend/models/event.dart';
import 'package:flutter_project_frontend/routes/event_service.dart';
import 'package:flutter_project_frontend/views/event_page.dart';
import 'package:flutter_project_frontend/views/widgets/event_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:textfield_search/textfield_search.dart';

class Home extends StatefulWidget {
  final Function? setMainComponent;
  const Home({
    Key? key,
    this.setMainComponent,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalStorage storage = LocalStorage('SCCBD');
  ScrollController _controller = ScrollController();
  TextEditingController findBooksController = TextEditingController();
  TextEditingController findEventsController = TextEditingController();
  TextEditingController findClubsController = TextEditingController();

  List<Event> _events = [];
  bool _isLoadingEvent = true;
  late String _locale;

  @override
  void initState() {
    super.initState();
    getEvents();
    findEventsController
        .addListener(() => findEvents(findEventsController.text));
  }

  Future<void> getEvents() async {
    _events = await EventService.getEvents();
    setState(() {
      _isLoadingEvent = false;
    });
  }

  String getStringCategories(List<dynamic> categories) {
    String txt = "";
    if (_locale == "en") {
      categories.forEach((element) {
        txt = txt + ", " + element.en;
      });
    } else if (_locale == "ca") {
      categories.forEach((element) {
        txt = txt + ", " + element.ca;
      });
    } else {
      categories.forEach((element) {
        txt = txt + ", " + element.es;
      });
    }
    return txt.substring(1);
  }

  List<String> getEventNames() {
    List<String> list = [];
    for (var event in _events) {
      list.add(event.name);
    }
    return list;
  }

  void findEvents(String name) {
    for (int i = 0; i < _events.length; i++) {
      if (_events[i].name == name) {
        widget.setMainComponent!(EventPage(
            setMainComponent: widget.setMainComponent,
            elementId: _events[i].name));
        findEventsController.text = "";
      }
    }
  }

  bool verifyAdminEvent(int index) {
    if (_events[index].admin.id == LocalStorage('SCCBD').getItem('userId')) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      Text(
                        'Events that may interest you',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  MediaQuery.of(context).size.width >= 1100
                      ? Row(
                          children: [
                            Container(
                              width: 250,
                              child: TextFieldSearch(
                                initialList: getEventNames(),
                                label: "Find",
                                controller: findEventsController,
                              ),
                            ),
                            const SizedBox(width: 25),
                          ],
                        )
                      : const SizedBox(width: 0),
                ],
              ),
              MediaQuery.of(context).size.width < 1100
                  ? Container(
                      width: 250,
                      child: TextFieldSearch(
                        initialList: getEventNames(),
                        label: "Find",
                        controller: findEventsController,
                      ),
                    )
                  : const SizedBox(height: 0),
              Container(
                height: 190,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: _isLoadingEvent
                      ? Column(
                          children: [
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              color: Theme.of(context).backgroundColor,
                            ),
                            const SizedBox(height: 200),
                          ],
                        )
                      : Stack(
                          children: [
                            ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _controller,
                              scrollDirection: Axis.horizontal,
                              itemCount: _events.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  child: EventCard(
                                    title: _events[index].name,
                                    date: _events[index].date.day.toString() +
                                        "-" +
                                        _events[index].date.month.toString() +
                                        "-" +
                                        _events[index].date.year.toString(),
                                    numberUsers: _events[index]
                                        .availableSpots
                                        .toString(),
                                    admin: verifyAdminEvent(index),
                                    setMainComponent: widget.setMainComponent,
                                    id: _events[index].id,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
