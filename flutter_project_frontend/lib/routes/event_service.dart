import 'dart:convert';
import 'package:flutter_project_frontend/models/editevent.dart';
import 'package:flutter_project_frontend/models/event.dart';
import 'package:flutter_project_frontend/models/joinEvent.dart';
import 'package:flutter_rsa_module/flutter_rsa_module.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

import '../models/leaveEvent.dart';
import '../models/newevent.dart';

class EventService {
  static Future<List<Event>> getEvents() async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/event/');

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('SCCBD').getItem('token')},
    );
    List data = jsonDecode(response.body);
    return Event.eventsFromSnapshot(data);
  }

  static Future<Event> getEvent(String name) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/event/$name/';
    Uri url = Uri.parse(baseUrl);

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('SCCBD').getItem('token')},
    );
    Object data = jsonDecode(response.body);
    return Event.fromJson(data);
  }

  static Future<bool> joinEvent(String eventName, List<String> pubKeys) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/event/join/$eventName');
    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('SCCBD').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(JoinEvent.toJson(JoinEvent(pubKeys: pubKeys))));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> leaveEvent(
      String eventName, RsaJsonPubKey pubKey, String signature) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/event/leave/$eventName');

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('SCCBD').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(LeaveEvent.toJson(
            LeaveEvent(pubKey: pubKey, signature: signature))));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> checkQrCode(
      String eventName, RsaJsonPubKey pubKey, String signature) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/event/qr/$eventName');

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('SCCBD').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(LeaveEvent.toJson(
            LeaveEvent(pubKey: pubKey, signature: signature))));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<String> newEvent(NewEventModel values) async {
    String userId = LocalStorage('SCCBD').getItem('userId');
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/event/$userId');

    var response = await http.post(url,
        headers: {
          "Authorization": LocalStorage('SCCBD').getItem('token'),
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
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/event/$id/';
    Uri url = Uri.parse(baseUrl);

    final response = await http.put(
      url,
      headers: {
        'authorization': LocalStorage('SCCBD').getItem('token'),
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
