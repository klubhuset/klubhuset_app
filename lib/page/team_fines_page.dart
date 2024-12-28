import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/repository/players_repository.dart';
import 'package:klubhuset/model/player_details.dart';

class TeamFinesPage extends StatefulWidget {
  @override
  State<TeamFinesPage> createState() => _TeamFinesPageState();
}

class _TeamFinesPageState extends State<TeamFinesPage> {
  late Future<List<PlayerDetails>> squad;

  @override
  void initState() {
    super.initState();
    squad = PlayersRepository.getSquad();
  }

  // ignore: unused_element
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
            leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context)
                      .popUntil((route) => route.settings.name == '/');
                },
                child: Icon(
                  semanticLabel: 'Tilbage',
                  CupertinoIcons.chevron_left,
                )),
            middle: Text('Bødekassen'),
          ),
          child: SafeArea(
            child: FutureHandler<List<PlayerDetails>>(
              future: squad,
              noDataFoundMessage: 'Ingen spillere fundet.',
              onSuccess: (context, data) {
                return Text('På vej');
              },
            ),
          ),
        ));
  }
}
