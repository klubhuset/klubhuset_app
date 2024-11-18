import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/match_poll_row_item.dart';
import 'package:klubhuset/model/match_poll.dart';
import 'package:klubhuset/model/match_poll_state.dart';
import 'package:klubhuset/page/match_polls_list_page.dart';
import 'package:klubhuset/repository/players_repository.dart';

class MatchPollPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var addedMatchPolls = MatchPollState.of(context);

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Ny afstemning'),
          trailing: GestureDetector(
              onTap: () => {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => addMatchPoll(addedMatchPolls)),
                    )
                  },
              child: Text('Gem',
                  style: TextStyle(
                      color: CupertinoColors.systemIndigo,
                      fontWeight: FontWeight.bold))),
        ),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Input the name of the match
              Form(
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: () {
                    Form.maybeOf(primaryFocus!.context!)?.save();
                  },
                  child: CupertinoFormSection.insetGrouped(
                      header: const Text('Navn på kampen'),
                      children: <Widget>[
                        CupertinoTextFormFieldRow(
                          placeholder: 'Indtast navn på kampen',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Indtast navnet på kampen';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                        )
                      ])),

              // Vote on the player of the match
              CupertinoListSection(
                  header: const Text('Stem på kampens spiller'),
                  children: getMatchPollRowItems()),
            ],
          ),
        )));
  }

  MatchPollsListPage addMatchPoll(MatchPollState matchPollState) {
    const matchPollToAdd = MatchPoll(7, 'Test', 8);
    matchPollState.addMatchPoll(matchPollToAdd);

    return MatchPollsListPage();
  }

  List<MatchPollRowItem> getMatchPollRowItems() {
    List<MatchPollRowItem> matchPollRowItems = [];

    final allPlayers = PlayersRepository.getAllPlayers();

    for (var player in allPlayers) {
      var matchPollItem =
          MatchPollRowItem(playerId: player.id, playerName: player.name);
      // Perhaps use onChange on the TextEditingController

      matchPollRowItems
          .add(MatchPollRowItem(playerId: player.id, playerName: player.name));
    }

    return matchPollRowItems;
  }
}
