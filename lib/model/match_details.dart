import 'package:klubhuset/model/match_poll_details.dart';

class MatchDetails {
  final int id;
  final String name;
  final DateTime matchDate;
  final MatchPollDetails? matchPollDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  MatchDetails(
      {required this.id,
      required this.name,
      required this.matchDate,
      this.matchPollDetails,
      required this.createdAt,
      required this.updatedAt});

  factory MatchDetails.fromJson(Map<String, dynamic> json) {
    return MatchDetails(
      id: json['id'],
      name: json['name'],
      matchDate: DateTime.parse(json['matchDate']),
      matchPollDetails: json['matchPoll'] != null
          ? MatchPollDetails.fromJson(json['matchPoll'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
