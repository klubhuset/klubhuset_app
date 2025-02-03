import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:klubhuset/model/create_player_fine_command.dart';
import 'package:klubhuset/model/fine_type_details.dart';
import 'package:klubhuset/model/player_fine_details.dart';

class FinesRepository {
  static Future<List<FineTypeDetails>> getFineTypes() async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/fine/types');

    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch fine types');
    }

    Iterable json = jsonDecode(response.body)['body'];

    return List<FineTypeDetails>.from(
        json.map((content) => FineTypeDetails.fromJson(content)));
  }

  static Future<List<PlayerFineDetails>> getAllPlayerFines() async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/fine/players');

    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch fines for players');
    }

    Iterable json = jsonDecode(response.body)['body'];

    return List<PlayerFineDetails>.from(
        json.map((content) => PlayerFineDetails.fromJson(content)));
  }

  static Future<List<int>> addFineForPlayers(
      List<CreatePlayerFineCommand> createPlayerFineCommands) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/fine/players');
    var body = createPlayerFineCommands
        .map((createPlayerFineCommand) => createPlayerFineCommand.toJson())
        .toList();

    var response = await http.post(url, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to add fine for player');
    }

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    Iterable json = responseBody['body'];

    return json.map((content) => content as int).toList();
  }
}
