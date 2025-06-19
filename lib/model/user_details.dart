class UserDetails {
  final int id;
  final String name;
  final String email;
  final bool isTeamOwner;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserDetails(
      {required this.id,
      required this.name,
      required this.email,
      required this.isTeamOwner,
      required this.createdAt,
      required this.updatedAt});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isTeamOwner: json['isTeamOwner'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
