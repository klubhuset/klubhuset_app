import 'package:flutter/foundation.dart';

class MatchPoll {
  final int id = UniqueKey().hashCode;
  final String matchName;
  final int playerOfTheMatchId;
  final int playerOfTheMatchVotes;
  final DateTime created = DateTime.now();

  MatchPoll(
      this.matchName, this.playerOfTheMatchId, this.playerOfTheMatchVotes);
}
