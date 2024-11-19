import 'package:flutter/cupertino.dart';
import 'package:klubhuset/helpers/date_helper.dart';
import 'package:klubhuset/model/match_polls_state.dart';
import 'package:klubhuset/page/create_match_poll_page.dart';
import 'package:klubhuset/repository/players_repository.dart';
import 'package:klubhuset/tab/home_tab.dart';
import 'package:provider/provider.dart';

class MatchPollsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO 1: Load existing match polls to MatchPollsState
    // Provider.of<MatchPollsState>(context, listen: false)
    //     .setMatchPolls(MatchPollsRepository.getMatchPolls());

    var matchPolls = context.watch<MatchPollsState>().matchPolls;

    var players = PlayersRepository.getAllPlayers();

    // TODO 1: Consider showing if an element is new in the list and sort match polls by newest date

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Afstemninger'),
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
                CupertinoPageRoute(builder: (context) => CreateMatchPollPage()),
              );
            },
            child: Icon(
              semanticLabel: 'Opret ny afstemning',
              CupertinoIcons.add,
            ),
          ),
        ),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ...List.generate(
                matchPolls.length,
                (index) => CupertinoListTile(
                  title: Text(players
                      .firstWhere(
                          (x) => x.id == matchPolls[index].playerOfTheMatchId)
                      .name),
                  subtitle: Text(
                      '${matchPolls[index].matchName} - d. ${DateHelper.getFormattedDate(matchPolls[index].created)}'),
                  additionalInfo: Text(
                      '${matchPolls[index].playerOfTheMatchVotes} stemmer'),
                ),
              ),
            ],
          ),
        )));
  }
}


/*
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
                  // CupertinoListTile(
                  //   title: Text('Skjold vs B93'),
                  //   subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  // ),
*/