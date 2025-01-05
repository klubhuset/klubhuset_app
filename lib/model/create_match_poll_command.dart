class CreateMatchPollCommand {
  final String matchId;
  final String playerOfTheMatchId;
  final String playerOfTheMatchVotes;

  CreateMatchPollCommand(
      this.matchId, this.playerOfTheMatchId, this.playerOfTheMatchVotes);

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'playerOfTheMatchId': playerOfTheMatchId,
      'playerOfTheMatchVotes': playerOfTheMatchVotes,
    };
  }
}
