import 'package:klubhuset/model/match_poll_user_votes_details.dart';
import 'package:klubhuset/model/user_details.dart';

class MatchPollDetails {
  final int id;
  final int matchId;
  final UserDetails playerOfTheMatchDetails;
  final int playerOfTheMatchVotes;
  final List<MatchPollUserVotesDetails> matchPollUserVotesDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  MatchPollDetails({
    required this.id,
    required this.matchId,
    required this.playerOfTheMatchDetails,
    required this.playerOfTheMatchVotes,
    required this.matchPollUserVotesDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MatchPollDetails.fromJson(Map<String, dynamic> json) {
    return MatchPollDetails(
      id: json['id'],
      matchId: json['matchId'],
      playerOfTheMatchDetails:
          UserDetails.fromJson(json['playerOfTheMatchDetails']),
      playerOfTheMatchVotes: json['playerOfTheMatchVotes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      matchPollUserVotesDetails: List<MatchPollUserVotesDetails>.from(
          json['matchPollUserVotesDetails']
              .map((x) => MatchPollUserVotesDetails.fromJson(x))),
    );
  }
}
