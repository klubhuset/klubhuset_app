import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubhuset/pages/match_poll_page.dart';

class MatchPollsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CupertinoListSection.insetGrouped(
                children: <CupertinoListTile>[
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
                  ),
                  CupertinoListTile(
                    title: Text('Skjold vs B93'),
                    subtitle: Text('Kampens spiller: Anders H. Brandt'),
                  ),
                ],
              )
            ],
          ),
        )));
  }
}
