class CreateMatchPollUserVoteCommand {
  String userId;
  String userVotes;

  CreateMatchPollUserVoteCommand(
      {required this.userId, required this.userVotes});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userVotes': userVotes,
    };
  }
}
