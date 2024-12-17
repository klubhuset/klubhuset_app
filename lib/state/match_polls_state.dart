import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:klubhuset/model/match_poll_details.dart';

class MatchPollsState extends ChangeNotifier {
  final List<MatchPollDetails> _matchPolls = [];

  MatchPollsState();

  UnmodifiableListView<MatchPollDetails> get matchPolls =>
      UnmodifiableListView(_matchPolls);

  void setMatchPolls(List<MatchPollDetails> matchPolls) {
    _matchPolls.clear();
    _matchPolls.addAll(matchPolls);
  }

  void addMatchPoll(MatchPollDetails matchPoll) {
    bool doesMatchPollAlreadyExistsByName =
        _matchPolls.any((x) => x.matchName == matchPoll.matchName);

    if (doesMatchPollAlreadyExistsByName) {
      return;
    }

    _matchPolls.add(matchPoll);
  }
}
