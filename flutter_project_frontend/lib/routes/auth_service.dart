import 'dart:convert';
import 'package:flutter_project_frontend/models/login.dart';
import 'package:flutter_project_frontend/models/register.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthService {
  final LocalStorage storage = LocalStorage('SCCBD');
  static var baseUrl = checkPlatform();
  //10.0.2.2 (emulador Android)

  static Future<String> verifyToken(String token) async {
    baseUrl = checkPlatform();

    var res = await http.post(Uri.parse(baseUrl + 'verifyToken'),
        headers: {'content-type': 'application/json'},
        body: json.encode({'token': token}));
    if (res.statusCode == 200) {
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(res.body)).message;
    }
  }

  Future<String> login(LoginModel credentials) async {
    baseUrl = checkPlatform();
    var res = await http.post(Uri.parse(baseUrl + 'signIn'),
        headers: {'content-type': 'application/json'},
        body: json.encode(LoginModel.toJson(credentials)));
    if (res.statusCode == 200) {
      var token = Token.fromJson(await jsonDecode(res.body));
      storage.setItem('token', token.toString());
      Map<String, dynamic> payload = Jwt.parseJwt(token.toString());

      storage.setItem('userId', payload['id']);
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(res.body)).message;
    }
  }

  Future<String> register(RegisterModel credentials) async {
    baseUrl = checkPlatform();
    var res = await http.post(Uri.parse(baseUrl + 'signUp'),
        headers: {'content-type': 'application/json'},
        body: json.encode(RegisterModel.toJson(credentials)));
    if (res.statusCode == 201) {
      var token = Token.fromJson(await jsonDecode(res.body));
      storage.setItem('token', token.toString());
      Map<String, dynamic> payload = Jwt.parseJwt(token.toString());

      storage.setItem('userId', payload['id']);
      return "201";
    } else {
      return Message.fromJson(await jsonDecode(res.body)).message;
    }
  }

  static String checkPlatform() {
    return const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/api/auth/';
  }
}

class Token {
  final String token;

  const Token({
    required this.token,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'] as String,
    );
  }

  @override
  String toString() {
    return token;
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
