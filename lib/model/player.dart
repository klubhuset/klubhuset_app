class PlayerDetails {
  final int id;
  final String name;
  final String email;
  final bool isTeamOwner;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlayerDetails(
      {required this.id,
      required this.name,
      required this.email,
      required this.isTeamOwner,
      required this.createdAt,
      required this.updatedAt});

  factory PlayerDetails.fromJson(Map<String, dynamic> json) {
    return PlayerDetails(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isTeamOwner: json['isTeamOwner'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
