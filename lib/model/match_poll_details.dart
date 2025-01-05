class MatchPollDetails {
  final int id;
  final int matchId;
  final int playerOfTheMatchId;
  final int playerOfTheMatchVotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  MatchPollDetails(
      {required this.id,
      required this.matchId,
      required this.playerOfTheMatchId,
      required this.playerOfTheMatchVotes,
      required this.createdAt,
      required this.updatedAt});

  factory MatchPollDetails.fromJson(Map<String, dynamic> json) {
    return MatchPollDetails(
      id: json['id'],
      matchId: json['matchId'],
      playerOfTheMatchId: json['playerOfTheMatchId'],
      playerOfTheMatchVotes: json['playerOfTheMatchVotes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
