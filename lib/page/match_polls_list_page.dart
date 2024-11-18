import 'package:flutter/cupertino.dart';
import 'package:klubhuset/model/match_poll_state.dart';
import 'package:klubhuset/model/test_state.dart';
import 'package:klubhuset/model/test_state_notifier.dart';
import 'package:klubhuset/page/match_poll_page.dart';
import 'package:klubhuset/repository/match_polls_repository.dart';

class MatchPollsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var addedMatchPolls = MatchPollState.of(context);
    // var allMatchPolls = MatchPollsRepository.getMatchPolls();

    // //addedMatchPolls.addMatchPolls(allMatchPolls);
    // for (var element in addedMatchPolls.getMatchPolls()) {
    //   print('Match poll: ${element.matchName} : ${element.playerOfTheMatchId}');
    // }

    final TestState testState = TestState();

    testState.setMatchPolls(MatchPollsRepository.getMatchPolls());

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Afstemninger'),
          trailing: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => MatchPollPage()),
              );
            },
            child: Icon(
              semanticLabel: 'Opret ny afstemning',
              CupertinoIcons.add,
            ),
          ),
        ),
        child: SafeArea(
            child: TestStateNotifier(
          testState: testState,
          child: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CupertinoListSection.insetGrouped(
                    children: <CupertinoListTile>[
                      CupertinoListTile(
                          title: Text(
                              'Length: ${testState.addedMatchPolls.length}')),
                    ],
                  )
                ],
              ),
            );
          }),
        )));
  }
}


/*

                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ),
                      CupertinoListTile(
                        title: Text('Skjold vs B93'),
                        subtitle: Text('Kampens spiller: Anders H. Brandt'),
                      ), */