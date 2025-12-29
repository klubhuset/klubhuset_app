import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:klubhuset/helpers/api_config.dart';
import 'package:klubhuset/model/add_user_to_team_command.dart';
import 'package:klubhuset/model/user_details.dart';
import 'package:http/http.dart' as http;

class UsersRepository {
  static Future<List<UserDetails>> getSquad() async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${ApiConfig.baseUrl}/user/all');

    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch squad');
    }

    Iterable json = jsonDecode(response.body)['body'];

    return List<UserDetails>.from(
        json.map((content) => UserDetails.fromJson(content)));
  }

  static Future<int> createPlayer(String name, String email) async {
    await dotenv.load(); // Initialize dotenv

    var url = Uri.parse('${ApiConfig.baseUrl}/user');

    AddUserToTeamCommand addUserToTeamCommand =
        AddUserToTeamCommand(name, email, false);

    var response = await http.post(url, body: addUserToTeamCommand.toJson());

    if (response.statusCode != 200) {
      throw Exception('Failed to add user');
    }

    var json = jsonDecode(response.body);

    return json['id'];
  }
}
