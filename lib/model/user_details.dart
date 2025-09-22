import 'package:klubhuset/model/team_details.dart';

class UserDetails {
  final int id;
  final String name;
  final String email;
  final bool isTeamOwner;
  final int roleId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TeamDetails teamDetails;

  UserDetails(
      {required this.id,
      required this.name,
      required this.email,
      required this.isTeamOwner,
      required this.roleId,
      required this.createdAt,
      required this.updatedAt,
      required this.teamDetails});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isTeamOwner: json['isTeamOwner'],
      roleId: json['roleId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      teamDetails: TeamDetails.fromJson(json['teamDetails']),
    );
  }
}
