class MatchPollUserVotesDetails {
  final int id;
  final int matchPollId;
  final int userId;
  final int numberOfVotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  MatchPollUserVotesDetails(
      {required this.id,
      required this.matchPollId,
      required this.userId,
      required this.numberOfVotes,
      required this.createdAt,
      required this.updatedAt});

  factory MatchPollUserVotesDetails.fromJson(Map<String, dynamic> json) {
    return MatchPollUserVotesDetails(
      id: json['id'],
      matchPollId: json['matchPollId'],
      userId: json['userId'],
      numberOfVotes: json['numberOfVotes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
