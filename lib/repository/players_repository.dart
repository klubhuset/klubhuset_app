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
  ];

  static List<Player> getAllPlayers() {
    return _allPlayers;
  }
}
