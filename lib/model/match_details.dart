class MatchDetails {
  final int id;
  final String name;
  final DateTime matchDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  MatchDetails(
      {required this.id,
      required this.name,
      required this.matchDate,
      required this.createdAt,
      required this.updatedAt});

  factory MatchDetails.fromJson(Map<String, dynamic> json) {
    return MatchDetails(
      id: json['id'],
      name: json['name'],
      matchDate: DateTime.parse(json['matchDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
