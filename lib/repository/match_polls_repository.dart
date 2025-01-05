import 'dart:convert';
import 'package:klubhuset/model/create_match_poll_command.dart';
import 'package:klubhuset/model/match_poll_details.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class MatchPollsRepository {
  static Future<List<MatchPollDetails>> getMatchPolls() async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/match/matchpolls/all');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable json = jsonDecode(response.body)['body'];

      return List<MatchPollDetails>.from(
          json.map((content) => MatchPollDetails.fromJson(content)));
    } else {
      throw Exception('Failed to fetch squad');
    }
  }

  static Future<int> createMatchPoll(
      int matchId, int playerOfTheMatchId, int numberOfVotes) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/match/matchpolls');

    CreateMatchPollCommand createMatchPollCommand = CreateMatchPollCommand(
        matchId.toString(),
        playerOfTheMatchId.toString(),
        numberOfVotes.toString());

    var response = await http.post(url, body: createMatchPollCommand.toJson());

    if (response.statusCode == 201) {
      throw Exception('Failed to create match poll');
    }

    var json = jsonDecode(response.body);

    return json['id'];
  }
}
