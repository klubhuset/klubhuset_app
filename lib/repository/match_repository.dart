import 'dart:convert';
import 'package:klubhuset/model/create_match_comand.dart';
import 'package:klubhuset/model/match_details.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MatchRepository {
  static final _secureStorage = FlutterSecureStorage();

  static Future<List<MatchDetails>> getMatches() async {
    await dotenv.load(); // Initialize dotenv

    // Get token
    final token = await _secureStorage.read(key: 'token');

    if (token == null) {
      throw Exception('No token found. User might not be logged in.');
    }

    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/match');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['body'];
      return List<MatchDetails>.from(
        json.map((content) => MatchDetails.fromJson(content)),
      );
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please log in again.');
    } else {
      throw Exception('Failed to fetch matches');
    }
  }

  static Future<int> createMatch(String name, DateTime matchDate) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/match');

    // TODO: Add address
    CreateMatchCommand createMatchCommand =
        CreateMatchCommand(name, '', matchDate);

    var response = await http.post(url, body: createMatchCommand.toJson());

    if (response.statusCode != 200) {
      throw Exception('Failed to create match');
    }

    var json = jsonDecode(response.body);

    return json['id'];
  }

  static Future<MatchDetails> getMatch(int id) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/match/$id');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)['body'];

      return MatchDetails.fromJson(json);
    } else {
      throw Exception('Failed to fetch match');
    }
  }
}
