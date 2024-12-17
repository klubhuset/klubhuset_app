import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/error_message.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/component/loading_indicator.dart';
import 'package:klubhuset/helpers/date_helper.dart';
import 'package:klubhuset/model/match_poll_details.dart';
import 'package:klubhuset/model/player_details.dart';
import 'package:klubhuset/repository/match_polls_repository.dart';
import 'package:klubhuset/repository/players_repository.dart';
import 'package:klubhuset/page/create_match_poll_page.dart';
import 'package:klubhuset/tab/home_tab.dart';

class MatchPollsListPage extends StatefulWidget {
  @override
  State<MatchPollsListPage> createState() => _MatchPollsListPageState();
}

class _MatchPollsListPageState extends State<MatchPollsListPage> {
  late Future<List<Map<String, dynamic>>> matchPollsData;

  @override
  void initState() {
    super.initState();
    // Fetch both match polls and squad data at once
    matchPollsData = _fetchMatchPollsData();
  }

  Future<List<Map<String, dynamic>>> _fetchMatchPollsData() async {
    // Fetching both matchPolls and squad data
    final squad = await PlayersRepository.getSquad();
    final matchPolls = await MatchPollsRepository.getMatchPolls();

    // Combine the two into one list of maps, matching players with their polls
    return matchPolls.map((poll) {
      final player =
          squad.firstWhere((player) => player.id == poll.playerOfTheMatchId);

      return {
        'matchPoll': poll,
        'player': player,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Afstemninger'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
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
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => CreateMatchPollPage()),
            );
          },
          child: Icon(
            CupertinoIcons.add,
            semanticLabel: 'Opret ny afstemning',
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: FutureHandler<List<Map<String, dynamic>>>(
            future: matchPollsData,
            onSuccess: (context, data) {
              // If data is available, build the list
              return ListView.builder(
                shrinkWrap:
                    true, // This is required avoid page and scroll issues
                padding: EdgeInsets.only(top: 20.0),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final dataToBeUsed = data[index];
                  final matchPoll =
                      dataToBeUsed['matchPoll'] as MatchPollDetails;
                  final player = dataToBeUsed['player'] as PlayerDetails;

                  return CupertinoListTile(
                    title: Text(player.name),
                    subtitle: Text(
                      '${matchPoll.matchName} - d. ${DateHelper.getFormattedDate(matchPoll.createdAt)}',
                    ),
                    additionalInfo: Text(
                      '${matchPoll.playerOfTheMatchVotes} stemmer',
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
