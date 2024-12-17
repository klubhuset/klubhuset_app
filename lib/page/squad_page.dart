import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/repository/players_repository.dart';
import 'package:klubhuset/page/add_player_to_squad_page.dart';
import 'package:klubhuset/tab/home_tab.dart';
import 'package:klubhuset/model/player_details.dart'; // Antagelse om PlayerDetails model

class SquadPage extends StatefulWidget {
  @override
  _SquadPageState createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
  late Future<List<PlayerDetails>> squad;

  @override
  void initState() {
    super.initState();
    squad = PlayersRepository.getSquad();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Truppen'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(
              context,
              CupertinoPageRoute(builder: (context) => HomeTab()),
            );
          },
          child: Icon(
            semanticLabel: 'Tilbage',
            CupertinoIcons.chevron_left,
          ),
        ),
        trailing: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => AddPlayerToSquadPage()),
            );
          },
          child: Icon(
            semanticLabel: 'Tilføj ny spiller',
            CupertinoIcons.add,
          ),
        ),
      ),
      child: SafeArea(
        child: FutureHandler<List<PlayerDetails>>(
          future: squad,
          noDataFoundMessage: 'Ingen spillere fundet.',
          onSuccess: (context, data) {
            return SingleChildScrollView(
              child: CupertinoListSection.insetGrouped(
                header: const Text('Spillere i truppen'),
                children: data.map((player) {
                  return CupertinoListTile(
                    title: Text(player.name),
                    subtitle: player.isTeamOwner ? Text('Holdleder') : null,
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
