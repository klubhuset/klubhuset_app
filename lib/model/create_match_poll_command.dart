class CreateMatchPollCommand {
  final String matchName;
  final int playerOfTheMatchId;
  final int playerOfTheMatchVotes;

  CreateMatchPollCommand(
      this.matchName, this.playerOfTheMatchId, this.playerOfTheMatchVotes);
}
