import 'dart:convert';

import 'package:klubhuset/model/player_details.dart';
import 'package:http/http.dart' as http;

class PlayersRepository {
  static List<PlayerDetails> _allPlayers = <PlayerDetails>[];

  static Future<List<PlayerDetails>> getSquad() async {
    var url = Uri.parse('http://localhost:3000/api/player/all');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable json = jsonDecode(response.body)['body'];

      return List<PlayerDetails>.from(
          json.map((content) => PlayerDetails.fromJson(content)));
    } else {
      throw Exception('Failed to fetch squad');
    }
  }

  static PlayerDetails getPlayer(int playerId) {
    return _allPlayers.firstWhere((x) => x.id == playerId);
  }

  static void addPlayer(String name, bool isTeamOwner) {
    bool doesPlayerNotAlreadyExist =
        !_allPlayers.any((x) => x.name.toLowerCase() == name.toLowerCase());

    if (doesPlayerNotAlreadyExist) {
      // TODO 1: Fix this
      // _allPlayers.add(Player(name, isTeamOwner));
    }
  }

  static void removePlayer(int playerId) {
    _allPlayers.removeWhere((x) => x.id == playerId);
  }

  static bool doesPlayerAlreadyExistByName(String name) {
    return _allPlayers.any((x) => x.name == name);
  }
}
