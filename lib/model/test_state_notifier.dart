import 'package:flutter/widgets.dart';
import 'package:klubhuset/model/match_poll.dart';
import 'package:klubhuset/model/test_state.dart';

class TestStateNotifier extends InheritedNotifier<TestState> {
  TestStateNotifier(
      {super.key, required TestState testState, required super.child});

  static List<MatchPoll> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TestStateNotifier>()!
        .notifier!
        .addedMatchPolls;
  }

  @override
  bool updateShouldNotify(covariant InheritedNotifier<TestState> oldWidget) {
    return notifier!.addedMatchPolls.length !=
        oldWidget.notifier!.addedMatchPolls.length;
  }
}
