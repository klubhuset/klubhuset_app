import 'package:flutter/foundation.dart';
import 'package:klubhuset/model/match_poll.dart';

class TestState with ChangeNotifier {
  List<MatchPoll> _addedMatchPolls = [];
  List<MatchPoll> get addedMatchPolls => _addedMatchPolls;

  void setMatchPolls(List<MatchPoll> matchPolls) {
    _addedMatchPolls = matchPolls;
    notifyListeners();
  }

  void addMatchPoll(MatchPoll matchPoll) {
    addedMatchPolls.add(matchPoll);
  }
}
