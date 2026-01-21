import 'package:kopa/model/user_details.dart';

class MatchRegistrationDetails {
  final int id;
  final UserDetails userDetails;
  final bool isUserParticipating;
  final DateTime createdAt;
  final DateTime updatedAt;

  MatchRegistrationDetails({
    required this.id,
    required this.userDetails,
    required this.isUserParticipating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MatchRegistrationDetails.fromJson(Map<String, dynamic> json) {
    return MatchRegistrationDetails(
      id: json['id'],
      userDetails: UserDetails.fromJson(json['userDetails']),
      isUserParticipating: json['isUserParticipating'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
