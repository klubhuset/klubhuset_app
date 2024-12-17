class MatchPollDetails {
  final int id;
  final String matchName;
  final int playerOfTheMatchId;
  final int playerOfTheMatchVotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  MatchPollDetails(
      {required this.id,
      required this.matchName,
      required this.playerOfTheMatchId,
      required this.playerOfTheMatchVotes,
      required this.createdAt,
      required this.updatedAt});

  factory MatchPollDetails.fromJson(Map<String, dynamic> json) {
    return MatchPollDetails(
      id: json['id'],
      matchName: json['matchName'],
      playerOfTheMatchId: json['playerOfTheMatchId'],
      playerOfTheMatchVotes: json['playerOfTheMatchVotes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
