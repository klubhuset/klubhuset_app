import 'package:klubhuset/model/match_poll.dart';
import 'package:klubhuset/model/player.dart';
import 'package:klubhuset/repository/players_repository.dart';

class MatchPollsRepository {
  static Player firstPlayer = PlayersRepository.getSquad().first;

  static List<MatchPoll> _allMatchPolls = <MatchPoll>[
    MatchPoll('Skjold vs Atalanta', firstPlayer.id, 4),
    MatchPoll('Skjold vs Arsenal', firstPlayer.id, 6),
    MatchPoll('Skjold vs FC Barcelona', firstPlayer.id, 2),
  ];

  static List<MatchPoll> getMatchPolls() {
    return _allMatchPolls;
  }
}
