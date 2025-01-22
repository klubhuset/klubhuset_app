import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:klubhuset/model/create_player_command.dart';
import 'package:klubhuset/model/player_details.dart';
import 'package:http/http.dart' as http;
import 'package:klubhuset/model/player_fine_details.dart';

class PlayersRepository {
  static Future<List<PlayerDetails>> getSquad() async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/player/all');

    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch squad');
    }

    Iterable json = jsonDecode(response.body)['body'];

    return List<PlayerDetails>.from(
        json.map((content) => PlayerDetails.fromJson(content)));
  }

  static Future<int> createPlayer(String name, String email) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/player');

    CreatePlayerCommand createPlayerCommand =
        CreatePlayerCommand(name, email, false);

    var response = await http.post(url, body: createPlayerCommand.toJson());

    if (response.statusCode != 200) {
      throw Exception('Failed to add player');
    }

    var json = jsonDecode(response.body);

    return json['id'];
  }

  static Future<List<PlayerFineDetails>> getAllPlayerFines() async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/player/fines');

    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch squad');
    }

    Iterable json = jsonDecode(response.body)['body'];

    var test = List<PlayerFineDetails>.from(
        json.map((content) => PlayerFineDetails.fromJson(content)));

    return test;
  }
}
