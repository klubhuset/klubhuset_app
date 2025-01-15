import 'dart:convert';
import 'package:klubhuset/model/create_match_poll_command.dart';
import 'package:klubhuset/model/create_match_poll_player_command.dart';
import 'package:klubhuset/model/match_poll_details.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:klubhuset/model/player_vote.dart';

class MatchPollsRepository {
  static Future<List<MatchPollDetails>> getMatchPolls() async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/match/matchpoll/all');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable json = jsonDecode(response.body)['body'];

      return List<MatchPollDetails>.from(
          json.map((content) => MatchPollDetails.fromJson(content)));
    } else {
      throw Exception('Failed to fetch match polls');
    }
  }

  static Future<MatchPollDetails> getMatchPoll(int id) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/match/matchpoll/$id');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)['body'];

      return MatchPollDetails.fromJson(json);
    } else {
      throw Exception('Failed to fetch match poll');
    }
  }

  static Future<int> createMatchPoll(
      int matchId, List<PlayerVote> playerVotes) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/match/matchpoll');

    List<CreateMatchPollPlayerVoteCommand> createMatchPollPlayerVoteCommands =
        playerVotes
            .map((playerVote) => CreateMatchPollPlayerVoteCommand(
                  playerId: playerVote.playerId.toString(),
                  playerVotes: playerVote.votes.toString(),
                ))
            .toList();

    CreateMatchPollCommand createMatchPollCommand = CreateMatchPollCommand(
        matchId.toString(), createMatchPollPlayerVoteCommands);

    var response = await http.post(url, body: createMatchPollCommand.toJson());

    if (response.statusCode == 201) {
      throw Exception('Failed to create match poll');
    }

    var json = jsonDecode(response.body);

    return json['id'];
  }
}
