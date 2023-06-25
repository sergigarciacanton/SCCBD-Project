import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_project_frontend/models/editevent.dart';
import 'package:flutter_project_frontend/models/newevent.dart';
import 'package:flutter_project_frontend/routes/event_service.dart';
import 'package:flutter_project_frontend/views/home_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../../models/event.dart';
import '../../models/user.dart';
import '../../routes/user_service.dart';

class NewEvent extends StatefulWidget {
  String? eventId;
  NewEvent({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final nameController = TextEditingController();
  final numSpotsController = TextEditingController();
  String eventDateController = DateTime.now().toString();
  String idController = "";
  bool _isLoading = true;
  late String _locale;

  List<String> usersController = List.empty(growable: true);

  late Event event;
  var dateTimeController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchEvent();
    isLoading = false;
  }

  var storage;

  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    idController = LocalStorage('BookHub').getItem('userName');
    return UserService.getUserByUserName(idController);
  }

  void fetchEvent() async {
    event = await EventService.getEvent(widget.eventId!);
    nameController.text = event.name;
    numSpotsController.text = event.numSpots.toString();
    setState(() {
      dateTimeController.text = event.date.toString();
      eventDateController = event.date.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width < 11000) {
      screenSize = screenSize / 5 * 4;
    }
    return Scaffold(
        appBar: AppBar(
          title: widget.eventId == null
              ? Text("N E W  E V E N T",
                  style: const TextStyle(fontWeight: FontWeight.bold))
              : Text("E D I T  E V E N T",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Image.network(
                        "https://img.icons8.com/ios7/12x/calendar--v3.png",
                        height: 200),
                    const SizedBox(
                      height: 20,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              labelText: "Name",
                              hintText: "Write the name of the event",
                              border: OutlineInputBorder()),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              labelText: "Name",
                              hintText: "Write the name of the event",
                              border: const OutlineInputBorder()),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: numSpotsController,
                          maxLines: 8,
                          maxLength: 500,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              labelText: "Description",
                              hintText: "Write the description of the event",
                              border: const OutlineInputBorder()),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: DateTimePicker(
                        controller: dateTimeController,
                        type: DateTimePickerType.date,
                        dateMask: 'dd/MM/yyyy',
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2030),
                        icon: const Icon(Icons.event),
                        dateLabelText: "Date",
                        onSaved: (val) => eventDateController = val!,
                        onChanged: (val) => eventDateController = val,
                        onFieldSubmitted: (val) => eventDateController = val,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select related categories',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: widget.eventId == null
                          ? Text(
                              "Create new event",
                              textScaleFactor: 1,
                            )
                          : Text(
                              "Edit event",
                              textScaleFactor: 1,
                            ),
                      onPressed: () async {
                        var response;
                        if (widget.eventId == null) {
                          response = await EventService.newEvent(NewEventModel(
                              name: nameController.text,
                              numSpots: int.parse(numSpotsController.text),
                              admin: idController,
                              date: DateTime.parse(eventDateController)));
                        } else {
                          response = await EventService.editEvent(
                              widget.eventId!,
                              EditEventModel(
                                  name: nameController.text,
                                  numSpots: int.parse(numSpotsController.text),
                                  date: DateTime.parse(eventDateController)));
                        }
                        if (response == "200") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScaffold()));
                        } else if (response == "201") {
                          usersController.add(idController);
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
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).backgroundColor,
                          onPrimary: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ])));
  }
}
