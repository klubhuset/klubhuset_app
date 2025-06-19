class UserVote {
  final int userId;
  int votes;

  UserVote({required this.userId, required this.votes});

  void setVotes(int votes) {
    this.votes = votes;
  }
}
