class MatchPollPlayerVotesDetails {
  int id;
  int matchPollId;
  int playerId;
  int numberOfVotes;
  DateTime createdAt;
  DateTime updatedAt;

  MatchPollPlayerVotesDetails(
      {required this.id,
      required this.matchPollId,
      required this.playerId,
      required this.numberOfVotes,
      required this.createdAt,
      required this.updatedAt});

  factory MatchPollPlayerVotesDetails.fromJson(Map<String, dynamic> json) {
    return MatchPollPlayerVotesDetails(
      id: json['id'],
      matchPollId: json['matchPollId'],
      playerId: json['playerId'],
      numberOfVotes: json['numberOfVotes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
