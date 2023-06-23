class RegisterModel {
  String name;
  String password;
  int type;

  RegisterModel({
    required this.name,
    required this.password,
    required this.type,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      name: json['name'],
      password: json['password'],
      type: json['type'],
    );
  }

  static Map<String, dynamic> toJson(RegisterModel credentials) {
    return {
      'name': credentials.name,
      'password': credentials.password,
      'type': credentials.type,
    };
  }
}
