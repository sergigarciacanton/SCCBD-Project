import 'dart:convert';
import 'package:flutter_project_frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class UserService {
  static Future<User> getUserByUserName(String userName) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/user/$userName';
    Uri url = Uri.parse(baseUrl);

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('SCCBD').getItem('token')},
    );
    Object data = jsonDecode(response.body);

    return User.fromJson(data);
  }

  static Future<List<User>> getUsers() async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/user/';
    Uri url = Uri.parse(baseUrl);

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('SCCBD').getItem('token')},
    );
    List data = jsonDecode(response.body);
    return User.usersFromSnapshot(data);
  }

  static Future<bool> updateUser(String name, int type) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/user/$name';
    Uri url = Uri.parse(baseUrl);

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('SCCBD').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({'name': name, 'type': type}));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> changePassword(
      String id, String password, String old) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/user/$id';
    Uri url = Uri.parse(baseUrl);

    final response = await http.post(url,
        headers: {
          'authorization': LocalStorage('SCCBD').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'password': password,
          'old': old,
        }));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> deleteAccount(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://192.168.1.39:3000') +
        '/api/user/$id';
    Uri url = Uri.parse(baseUrl);

    final response = await http.delete(
      url,
      headers: {
        'authorization': LocalStorage('SCCBD').getItem('token'),
      },
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
