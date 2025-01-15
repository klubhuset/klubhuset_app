class CreateMatchPollPlayerVoteCommand {
  String playerId;
  String playerVotes;

  CreateMatchPollPlayerVoteCommand(
      {required this.playerId, required this.playerVotes});

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerVotes': playerVotes,
    };
  }
}
