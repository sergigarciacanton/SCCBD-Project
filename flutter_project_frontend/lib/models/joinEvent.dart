class JoinEvent {
  List<String> pubKeys;

  JoinEvent({required this.pubKeys});

  static Map<String, dynamic> toJson(JoinEvent values) {
    return {'pubKeys': values.pubKeys};
  }
}
