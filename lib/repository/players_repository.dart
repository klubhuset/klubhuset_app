import 'package:klubhuset/model/player.dart';

class PlayersRepository {
  static const _allPlayers = <Player>[
    Player(1, 'Anders H. Brandt', true),
    Player(2, 'Christopher V. H. Nielsen', false),
    Player(3, 'Torben Hansen', false),
    Player(4, 'Niels Nielsen', false),
    Player(5, 'Thimotheus Frederiksen', false),
    Player(6, 'Lennard Andersen', false),
    Player(7, 'Tobias Olsen', false),
    Player(8, 'Peter Rasmussen', false),
    Player(9, 'Erik Bulmer', false),
    Player(10, 'Werner Sørensen', false),
    Player(11, 'Ulrik H. J. Abrahamsen', false),
    Player(12, 'Birger Ulriksen', false),
  ];

  static List<Player> getAllPlayers() {
    return _allPlayers;
  }
}
