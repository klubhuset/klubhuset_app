import 'dart:convert';

import 'package:klubhuset/model/create_match_poll_user_command.dart';

class CreateMatchPollCommand {
  final String matchId;
  final List<CreateMatchPollUserVoteCommand> createMatchPollUserVoteCommands;

  CreateMatchPollCommand(this.matchId, this.createMatchPollUserVoteCommands);

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'createMatchPollUserVoteCommands': jsonEncode(
          createMatchPollUserVoteCommands.map((e) => e.toJson()).toList())
    };
  }
}
