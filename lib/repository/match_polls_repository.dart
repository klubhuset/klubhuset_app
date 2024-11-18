import 'package:klubhuset/model/match_poll.dart';

class MatchPollsRepository {
  static const _allMatchPolls = <MatchPoll>[
    MatchPoll(1, 'Skjold vs Atalanta', 1),
    MatchPoll(2, 'Skjold vs Arsenal', 1),
    MatchPoll(3, 'Skjold vs FC Barcelona', 1),
  ];

  static List<MatchPoll> getMatchPolls() {
    return _allMatchPolls;
  }
}
