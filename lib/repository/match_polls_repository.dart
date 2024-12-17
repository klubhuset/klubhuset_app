import 'dart:convert';
import 'package:klubhuset/model/match_poll_details.dart';

import 'package:http/http.dart' as http;

class MatchPollsRepository {
  static Future<List<MatchPollDetails>> getMatchPolls() async {
    var url = Uri.parse('http://localhost:3000/api/match/matchpolls/all');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable json = jsonDecode(response.body)['body'];

      return List<MatchPollDetails>.from(
          json.map((content) => MatchPollDetails.fromJson(content)));
    } else {
      throw Exception('Failed to fetch squad');
    }
  }
}
