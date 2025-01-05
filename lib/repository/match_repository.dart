import 'dart:convert';
import 'package:klubhuset/model/create_match_comand.dart';
import 'package:klubhuset/model/match_details.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class MatchRepository {
  static Future<List<MatchDetails>> getMatches() async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/match');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable json = jsonDecode(response.body)['body'];

      return List<MatchDetails>.from(
          json.map((content) => MatchDetails.fromJson(content)));
    } else {
      throw Exception('Failed to fetch matches');
    }
  }

  static Future<int> createMatch(String name, DateTime matchDate) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/match');

    CreateMatchCommand createMatchCommand = CreateMatchCommand(name, matchDate);

    var response = await http.post(url, body: createMatchCommand.toJson());

    if (response.statusCode != 200) {
      throw Exception('Failed to create match');
    }

    var json = jsonDecode(response.body);

    return json['id'];
  }
}
