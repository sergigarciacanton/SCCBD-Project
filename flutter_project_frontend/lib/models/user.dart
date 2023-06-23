class User {
  String id;
  String name;
  int type;

  User({required this.id, required this.name, required this.type});

  factory User.fromJson(dynamic json) {
    var id = json['_id'] as String;
    var name = json['name'] as String;
    var type = json['type'] as int;

    var u = User(id: id, name: name, type: type);
    return u;
  }

  static List<User> usersFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return User.fromJson(data);
    }).toList();
  }

//todo arreclar els subobjectes
  static Map<String, dynamic> toJson(User values) {
    return {
      '_id': values.id,
      'name': values.name,
      'type': values.type,
    };
  }
}
