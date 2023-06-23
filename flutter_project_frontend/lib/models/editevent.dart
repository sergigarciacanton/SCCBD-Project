class EditEventModel {
  String name;
  DateTime date;
  int numSpots;

  EditEventModel(
      {required this.name, required this.date, required this.numSpots});

  factory EditEventModel.fromJson(Map<String, dynamic> json) {
    return EditEventModel(
        name: json['name'],
        date: DateTime.parse((json['date'] as String).replaceAll("T", " ")),
        numSpots: json['numSpots']);
  }

  static Map<String, dynamic> toJson(EditEventModel credentials) {
    return {
      'name': credentials.name,
      'date': credentials.date.toString(),
      'numSpots': credentials.numSpots
    };
  }
}
