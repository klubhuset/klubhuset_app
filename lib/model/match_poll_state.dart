import 'package:flutter/cupertino.dart';
import 'package:klubhuset/model/match_poll.dart';

class MatchPollState extends InheritedWidget {
  final List<MatchPoll> addedMatchPolls;

  const MatchPollState(
      {super.key, required this.addedMatchPolls, required super.child});

  static MatchPollState of(BuildContext context) {
    // This method looks for the nearest `MyState` widget ancestor.
    final result = context.dependOnInheritedWidgetOfExactType<MatchPollState>();

    assert(result != null, 'No MyState found in context');

    return result!;
  }

  List<MatchPoll> getMatchPolls() {
    return addedMatchPolls;
  }

  void addMatchPoll(MatchPoll matchPoll) {
    addedMatchPolls.add(matchPoll);
  }

  void addMatchPolls(List<MatchPoll> matchPollsToAdd) {
    addedMatchPolls.addAll(matchPollsToAdd);
  }

  @override
  // This method should return true if the old widget's data is different
  // from this widget's data. If true, any widgets that depend on this widget
  // by calling `of()` will be re-built.
  bool updateShouldNotify(MatchPollState oldWidget) =>
      addedMatchPolls.length != oldWidget.addedMatchPolls.length;
}
