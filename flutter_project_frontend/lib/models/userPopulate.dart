class UserPopulate {
  String id;
  String name;

  UserPopulate({required this.id, required this.name});

  factory UserPopulate.fromJson(dynamic json) {
    var userName = json['userName'] as String;

    var u = UserPopulate(
      id: json['_id'] as String,
      name: userName,
    );
    return u;
  }

  static List<UserPopulate> usersFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return UserPopulate.fromJson(data);
    }).toList();
  }
}
