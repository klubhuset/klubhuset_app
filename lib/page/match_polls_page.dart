import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/future_handler.dart';
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
  late Future<Map<String, dynamic>> matchPollsData;

  @override
  void initState() {
    super.initState();
    // Fetch both match polls and squad data at once
    matchPollsData = _fetchMatchPollsData();
  }

  Future<Map<String, dynamic>> _fetchMatchPollsData() async {
    // Fetching both matchPolls and squad data
    final squad = await PlayersRepository.getSquad();
    final matchPolls = await MatchPollsRepository.getMatchPolls();

    // Combine the two into one map
    return {
      'squad': squad,
      'matchPolls': matchPolls.map((poll) {
        final player =
            squad.firstWhere((player) => player.id == poll.playerOfTheMatchId);
        return {
          'matchPoll': poll,
          'player': player,
        };
      }).toList(),
    };
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
          onPressed: () async {
            final data = await matchPollsData;
            final squad = data['squad'] as List<PlayerDetails>;
            final matchPolls = data['matchPolls'] as List<MatchPollDetails>;

            if (context.mounted) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => CreateMatchPollPage(
                          squad: squad,
                          matchPolls: matchPolls,
                        )),
              );
            }
          },
          child: Icon(
            CupertinoIcons.add,
            semanticLabel: 'Opret ny afstemning',
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: FutureHandler<Map<String, dynamic>>(
            future: matchPollsData,
            noDataFoundMessage: 'Ingen afstemninger fundet.',
            onSuccess: (context, data) {
              final matchPolls =
                  data['matchPolls'] as List<Map<String, dynamic>>;

              // If data is available, build the list
              return ListView.builder(
                shrinkWrap:
                    true, // This is required avoid page and scroll issues
                padding: EdgeInsets.only(top: 20.0),
                itemCount: matchPolls.length,
                itemBuilder: (context, index) {
                  final dataToBeUsed = matchPolls[index];
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
