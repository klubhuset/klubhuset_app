import 'package:klubhuset/model/player.dart';

class PlayersRepository {
  static List<Player> _allPlayers = <Player>[
    Player('Anders H. Brandt', true),
    Player('Christopher V. H. Nielsen', false),
    Player('Torben Hansen', false),
    Player('Niels Nielsen', false),
    Player('Thimotheus Frederiksen', false),
    Player('Lennard Andersen', false),
    Player('Tobias Olsen', false),
    Player('Peter Rasmussen', false),
    Player('Erik Bulmer', false),
    Player('Werner Sørensen', false),
    Player('Ulrik H. J. Abrahamsen', false),
    Player('Birger Ulriksen', false),
    Player('Lars Larsen', false),
    Player('Ulrik Thomsen', false),
    Player('Mads Mikkelsen Thomsen', false),
  ];

  static List<Player> getSquad() {
    return _allPlayers;
  }

  static Player getPlayer(int playerId) {
    return _allPlayers.firstWhere((x) => x.id == playerId);
  }

  static void addPlayer(String name, bool isTeamOwner) {
    bool doesPlayerNotAlreadyExist =
        !_allPlayers.any((x) => x.name.toLowerCase() == name.toLowerCase());

    if (doesPlayerNotAlreadyExist) {
      _allPlayers.add(Player(name, isTeamOwner));
    }
  }

  static void removePlayer(int playerId) {
    _allPlayers.removeWhere((x) => x.id == playerId);
  }

  static bool doesPlayerAlreadyExistByName(String name) {
    return _allPlayers.any((x) => x.name == name);
  }
}
