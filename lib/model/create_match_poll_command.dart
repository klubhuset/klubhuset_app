class CreateMatchPollCommand {
  final String matchName;
  final String playerOfTheMatchId;
  final String playerOfTheMatchVotes;

  CreateMatchPollCommand(
      this.matchName, this.playerOfTheMatchId, this.playerOfTheMatchVotes);

  Map<String, dynamic> toJson() {
    return {
      'matchName': matchName,
      'playerOfTheMatchId': playerOfTheMatchId,
      'playerOfTheMatchVotes': playerOfTheMatchVotes,
    };
  }
}
