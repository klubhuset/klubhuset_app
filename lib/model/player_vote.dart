class PlayerVote {
  final int playerId;
  int votes;

  PlayerVote({required this.playerId, required this.votes});

  void setVotes(int votes) {
    this.votes = votes;
  }
}
