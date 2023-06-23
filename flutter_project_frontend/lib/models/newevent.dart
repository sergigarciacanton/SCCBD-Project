import 'package:flutter_project_frontend/models/userPopulate.dart';

class NewEventModel {
  String name;
  DateTime date;
  dynamic admin;
  int numSpots;

  NewEventModel(
      {required this.name,
      required this.admin,
      required this.date,
      required this.numSpots});

  factory NewEventModel.fromJson(dynamic json) {
    return NewEventModel(
        name: json['name'] as String,
        admin: json['admin'].toString().contains('{')
            ? UserPopulate.fromJson(json['admin'])
            : json['admin'],
        date: DateTime.parse((json['date'] as String).replaceAll("T", " ")),
        numSpots: json['numSpots'] as int);
  }

  static Map<String, dynamic> toJson(NewEventModel values) {
    return {
      'name': values.name,
      'admin': values.admin,
      'date': values.date.toString(),
      'numSpots': values.numSpots
    };
  }

  static List<NewEventModel> eventsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return NewEventModel.fromJson(data);
    }).toList();
  }
}
