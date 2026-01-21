import 'package:kopa/model/match_event_details.dart';
import 'package:kopa/model/match_poll_details.dart';
import 'package:kopa/model/match_registration_details.dart';

class MatchDetails {
  final int id;
  final String homeTeam;
  final String awayTeam;
  final DateTime date;
  final DateTime? meetingTime;
  final String location;
  final String? notes;
  final MatchPollDetails? matchPollDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? homeTeamScore;
  final int? awayTeamScore;
  final bool isCurrentUserRegistered;
  final List<MatchRegistrationDetails>? matchRegistrationDetailsList;
  final List<MatchEventDetails>? matchEventDetailsList;

  MatchDetails({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.date,
    this.meetingTime,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.matchPollDetails,
    this.homeTeamScore,
    this.awayTeamScore,
    this.isCurrentUserRegistered = false,
    this.matchRegistrationDetailsList = const [],
    this.matchEventDetailsList = const [],
  });

  factory MatchDetails.fromJson(Map<String, dynamic> json) {
    return MatchDetails(
      id: json['id'],
      homeTeam: json['homeTeam'],
      awayTeam: json['awayTeam'],
      date: DateTime.parse(json['date']),
      meetingTime: _parseMeetingTime(json['meetingTime']),
      location: json['location'],
      notes: json['notes'],
      matchPollDetails: json['matchPoll'] != null
          ? MatchPollDetails.fromJson(json['matchPoll'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      homeTeamScore: json['homeTeamScore'],
      awayTeamScore: json['awayTeamScore'],
      isCurrentUserRegistered: json['isCurrentUserRegistered'],
      matchRegistrationDetailsList: json['matchRegistrationDetailsList'] != null
          ? List<MatchRegistrationDetails>.from(
              json['matchRegistrationDetailsList']
                  .map((x) => MatchRegistrationDetails.fromJson(x)))
          : [],
      matchEventDetailsList: json['matchEventDetailsList'] != null
          ? List<MatchEventDetails>.from(json['matchEventDetailsList']
              .map((x) => MatchEventDetails.fromJson(x)))
          : [],
    );
  }

  get matchName {
    return '$homeTeam vs $awayTeam';
  }

  get hasMatchBeenPlayed {
    return homeTeamScore != null && awayTeamScore != null;
  }
}

DateTime? _parseMeetingTime(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  final re = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)(?::([0-5]\d))?$');
  final m = re.firstMatch(s);
  if (m != null) {
    final h = int.parse(m.group(1)!);
    final mm = int.parse(m.group(2)!);
    final ss = m.group(3) != null ? int.parse(m.group(3)!) : 0;
    return DateTime.utc(1970, 1, 1, h, mm, ss);
  }
  // Ellers prøv ISO
  return DateTime.parse(s);
}
