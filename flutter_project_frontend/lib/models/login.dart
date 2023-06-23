class LoginModel {
  String name;
  String? password;

  LoginModel({required this.name, this.password});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(name: json['name'], password: json['password']);
  }

  static Map<String, dynamic> toJson(LoginModel credentials) {
    return {
      'name': credentials.name,
      'password': credentials.password,
    };
  }
}
