import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:klubhuset/model/create_player_fine_command.dart';
import 'package:klubhuset/model/create_player_fines_command.dart';
import 'package:klubhuset/model/fine_box_details.dart';
import 'package:klubhuset/model/fine_type_details.dart';

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

  static Future<FineBoxDetails> getFineBox() async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/fine/fine_box');

    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch fine box');
    }

    var json = jsonDecode(response.body)['body'];

    return FineBoxDetails.fromJson(json);
  }

  static Future<List<int>> addFineForPlayers(
      List<CreatePlayerFineCommand> createPlayerFineCommands) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${dotenv.env['API_BASE_URL']}/fine/players');

    var createPlayerFinesCommand =
        CreatePlayerFinesCommand(createPlayerFineCommands);

    var response =
        await http.post(url, body: createPlayerFinesCommand.toJson());

    if (response.statusCode != 200) {
      throw Exception('Failed to add fine for player');
    }

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    Iterable json = responseBody['body'];

    return json.map((content) => content as int).toList();
  }
}
