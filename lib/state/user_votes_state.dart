import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:kopa/model/user_vote.dart';

class UserVotesState extends ChangeNotifier {
  final List<UserVote> _userVotes = [];

  UserVotesState();

  UnmodifiableListView<UserVote> get userVotes =>
      UnmodifiableListView(_userVotes);

  void addUserVote(UserVote userVote) {
    bool doesUserHaveNotVotesYet =
        !_userVotes.any((x) => x.userId == userVote.userId);

    if (doesUserHaveNotVotesYet) {
      _userVotes.add(userVote);
      notifyListeners();
    } else {
      updateUserVote(userVote.userId, userVote.votes);
    }
  }

  void updateUserVote(int userId, int votes) {
    if (votes == 0) {
      _userVotes.removeWhere((x) => x.userId == userId);
    } else {
      _userVotes[_userVotes.indexWhere((x) => x.userId == userId)]
          .setVotes(votes);
    }

    notifyListeners();
  }

  void removeAllUserVotes() {
    _userVotes.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
