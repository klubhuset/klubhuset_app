import 'package:klubhuset/model/match_poll_details.dart';
import 'package:klubhuset/model/match_registration_details.dart';

class MatchDetails {
  final int id;
  final String firstTeam;
  final String secondTeam;
  final DateTime date;
  final String location;
  final String? notes;
  final MatchPollDetails? matchPollDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCurrentUserRegistered;
  final List<MatchRegistrationDetails>? matchRegistrationDetailsList;

  MatchDetails({
    required this.id,
    required this.firstTeam,
    required this.secondTeam,
    required this.date,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.matchPollDetails,
    this.isCurrentUserRegistered = false,
    this.matchRegistrationDetailsList = const [],
  });

  factory MatchDetails.fromJson(Map<String, dynamic> json) {
    return MatchDetails(
      id: json['id'],
      firstTeam: json['firstTeam'],
      secondTeam: json['secondTeam'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      notes: json['notes'],
      matchPollDetails: json['matchPoll'] != null
          ? MatchPollDetails.fromJson(json['matchPoll'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isCurrentUserRegistered: json['isCurrentUserRegistered'],
      matchRegistrationDetailsList: json['matchRegistrationDetailsList'] != null
          ? List<MatchRegistrationDetails>.from(
              json['matchRegistrationDetailsList']
                  .map((x) => MatchRegistrationDetails.fromJson(x)))
          : [],
    );
  }

  get matchName {
    return '$firstTeam vs $secondTeam';
  }
}
