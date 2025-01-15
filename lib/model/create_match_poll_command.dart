import 'dart:convert';

import 'package:klubhuset/model/create_match_poll_player_command.dart';

class CreateMatchPollCommand {
  final String matchId;
  final List<CreateMatchPollPlayerVoteCommand>
      createMatchPollPlayerVoteCommands;

  CreateMatchPollCommand(this.matchId, this.createMatchPollPlayerVoteCommands);

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'createMatchPollPlayerVoteCommands': jsonEncode(
          createMatchPollPlayerVoteCommands.map((e) => e.toJson()).toList())
    };
  }
}
