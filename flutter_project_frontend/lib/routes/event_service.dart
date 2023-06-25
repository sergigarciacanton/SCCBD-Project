import 'dart:convert';
import 'package:flutter_project_frontend/models/editevent.dart';
import 'package:flutter_project_frontend/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

import '../models/newevent.dart';

class EventService {
  static Future<List<Event>> getEvents() async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/api/event/');

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    return Event.eventsFromSnapshot(data);
  }

  static Future<Event> getEvent(String name) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/api/event/$name/';
    Uri url = Uri.parse(baseUrl);

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);
    return Event.fromJson(data);
  }

  static Future<bool> joinEvent(String eventName) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/api/event/join/$eventName');

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(''));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> leaveEvent(String eventName) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/api/event/leave/$eventName');

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(''));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<String> newEvent(NewEventModel values) async {
    String userId = LocalStorage('BookHub').getItem('userId');
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/api/event/$userId');

    var response = await http.post(url,
        headers: {
          "Authorization": LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(NewEventModel.toJson(values)));
    if (response.statusCode == 201) {
      return "201";
    } else {
      return Message.fromJson(await jsonDecode(response.body)).message;
    }
  }

  static Future<String> editEvent(String id, EditEventModel event) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/api/event/$id/';
    Uri url = Uri.parse(baseUrl);

    final response = await http.put(
      url,
      headers: {
        'authorization': LocalStorage('BookHub').getItem('token'),
        "Content-Type": "application/json"
      },
      body: json.encode(EditEventModel.toJson(event)),
    );
    if (response.statusCode == 200) {
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(response.body)).message;
    }
  }
}

class Message {
  final String message;

  const Message({
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'] as String,
    );
  }

  @override
  String toString() {
    return message;
  }
}
