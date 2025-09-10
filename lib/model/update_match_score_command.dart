class UpdateMatchScoreCommand {
  final int matchId;
  final int homeTeamScore;
  final int awayTeamScore;

  UpdateMatchScoreCommand({
    required this.matchId,
    required this.homeTeamScore,
    required this.awayTeamScore,
  });

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'homeTeamScore': homeTeamScore,
      'awayTeamScore': awayTeamScore,
    };
  }
}
