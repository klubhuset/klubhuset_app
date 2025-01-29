import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/repository/players_repository.dart';
import 'package:klubhuset/page/squad/add_player_to_squad_page.dart';
import 'package:klubhuset/model/player_details.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SquadPage extends StatefulWidget {
  @override
  State<SquadPage> createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
  late Future<List<PlayerDetails>> squad;

  @override
  void initState() {
    super.initState();
    squad = PlayersRepository.getSquad();
  }

  Future<void> _refreshSquad() async {
    setState(() {
      squad = PlayersRepository.getSquad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity,
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGrey6,
          navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            middle: Text('Truppen'),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context)
                    .popUntil((route) => route.settings.name == '/');
              },
              child: Icon(
                semanticLabel: 'Tilbage',
                CupertinoIcons.chevron_left,
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                final squadData = await squad;

                if (context.mounted) {
                  final result = await showCupertinoModalBottomSheet(
                    expand: true,
                    context: context,
                    builder: (context) => AddPlayerToSquadPage(
                      squad: squadData,
                    ),
                  );

                  if (result == true) {
                    _refreshSquad(); // Refresh the squad if a new player was added
                  }
                }
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
                    dividerMargin: 0,
                    additionalDividerMargin: 0,
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
        ));
  }
}
