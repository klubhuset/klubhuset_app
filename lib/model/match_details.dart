import 'package:klubhuset/model/match_poll_details.dart';

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
    );
  }

  get matchName {
    return '$firstTeam vs $secondTeam';
  }
}
