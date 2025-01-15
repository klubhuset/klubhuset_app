import 'package:klubhuset/model/match_poll_player_votes_details.dart';
import 'package:klubhuset/model/player_details.dart';

class MatchPollDetails {
  final int id;
  final int matchId;
  final PlayerDetails playerOfTheMatchDetails;
  final int playerOfTheMatchVotes;
  final List<MatchPollPlayerVotesDetails> matchPollPlayerVotesDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  MatchPollDetails({
    required this.id,
    required this.matchId,
    required this.playerOfTheMatchDetails,
    required this.playerOfTheMatchVotes,
    required this.matchPollPlayerVotesDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MatchPollDetails.fromJson(Map<String, dynamic> json) {
    return MatchPollDetails(
      id: json['id'],
      matchId: json['matchId'],
      playerOfTheMatchDetails:
          PlayerDetails.fromJson(json['playerOfTheMatchDetails']),
      playerOfTheMatchVotes: json['playerOfTheMatchVotes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      matchPollPlayerVotesDetails: List<MatchPollPlayerVotesDetails>.from(
          json['matchPollPlayerVotesDetails']
              .map((x) => MatchPollPlayerVotesDetails.fromJson(x))),
    );
  }
}
