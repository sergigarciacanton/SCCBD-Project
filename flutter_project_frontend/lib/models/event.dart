import 'userPopulate.dart';

class Event {
  String id;
  String name;
  DateTime date;
  dynamic admin;
  int numSpots;
  int availableSpots;

  Event(
      {required this.id,
      required this.name,
      required this.date,
      required this.admin,
      required this.numSpots,
      required this.availableSpots});

  factory Event.fromJson(dynamic json) {
    return Event(
        id: json['_id'] as String,
        name: json['name'] as String,
        admin: json['admin'].toString().contains('{')
            ? UserPopulate.fromJson(json['admin'])
            : json['admin'],
        date: DateTime.parse((json['date'] as String).replaceAll("T", " ")),
        numSpots: json['numSpots'] as int,
        availableSpots: json['availableSpots'] as int);
  }

  static List<Event> eventsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Event.fromJson(data);
    }).toList();
  }
}
