import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:klubhuset/model/match_poll.dart';

class MatchPollsState extends ChangeNotifier {
  final List<MatchPoll> _matchPolls = [];

  MatchPollsState();

  UnmodifiableListView<MatchPoll> get matchPolls =>
      UnmodifiableListView(_matchPolls);

  void setMatchPolls(List<MatchPoll> matchPolls) {
    _matchPolls.clear();
    _matchPolls.addAll(matchPolls);
  }

  void addMatchPoll(MatchPoll matchPoll) {
    bool doesMatchPollAlreadyExistsByName =
        _matchPolls.any((x) => x.matchName == matchPoll.matchName);

    if (doesMatchPollAlreadyExistsByName) {
      return;
    }

    _matchPolls.add(matchPoll);
  }
}
