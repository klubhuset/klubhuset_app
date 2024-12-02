import 'package:flutter/cupertino.dart';
import 'package:klubhuset/page/add_player_to_squad_page.dart';
import 'package:klubhuset/repository/players_repository.dart';
import 'package:klubhuset/tab/home_tab.dart';

class SquadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var squad = PlayersRepository.getSquad();

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Truppen'),
          leading: GestureDetector(
            onTap: () {
              // TODO 1 (CVHN): This does not work.
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
                CupertinoPageRoute(
                    builder: (context) => AddPlayerToSquadPage()),
              );
            },
            child: Icon(
              semanticLabel: 'Tilføj ny spiller',
              CupertinoIcons.add,
            ),
          ),
        ),
        child: SafeArea(
            child: SingleChildScrollView(
          child: CupertinoListSection.insetGrouped(
            header: const Text('Spillere i truppen'),
            children: <Widget>[
              ...List.generate(
                squad.length,
                (index) => CupertinoListTile(
                  title: Text(squad[index].name),
                  subtitle: Text((squad[index].isTeamOwner ? 'Holdleder' : '')),
                ),
              ),
            ],
          ),
        )));
  }
}
