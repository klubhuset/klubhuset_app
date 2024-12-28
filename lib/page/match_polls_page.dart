import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/helpers/date_helper.dart';
import 'package:klubhuset/model/match_poll_details.dart';
import 'package:klubhuset/model/player_details.dart';
import 'package:klubhuset/repository/match_polls_repository.dart';
import 'package:klubhuset/repository/players_repository.dart';
import 'package:klubhuset/page/create_match_poll_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
    return SizedBox(
        height: double.infinity,
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGrey6,
          navigationBar: CupertinoNavigationBar(
            transitionBetweenRoutes: false,
            middle: Text('Afstemninger'),
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
                final data = await matchPollsData;
                final squad = data['squad'] as List<PlayerDetails>;
                final matchPolls = (data['matchPolls']
                        as List<Map<String, dynamic>>)
                    .map((matchPollsDataElement) =>
                        matchPollsDataElement['matchPoll'] as MatchPollDetails)
                    .toList();

                if (context.mounted) {
                  showCupertinoModalBottomSheet(
                    expand: true,
                    context: context,
                    builder: (context) => CreateMatchPollPage(
                      squad: squad,
                      matchPolls: matchPolls,
                    ),
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
                  return CupertinoListSection.insetGrouped(
                    dividerMargin: 0,
                    additionalDividerMargin: 0,
                    children: List.generate(
                      matchPolls.length,
                      (index) {
                        final dataToBeUsed = matchPolls[index];
                        final matchPoll =
                            dataToBeUsed['matchPoll'] as MatchPollDetails;
                        final player = dataToBeUsed['player'] as PlayerDetails;

                        return CupertinoListTile(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 20, right: 20),
                          title: Text(player.name),
                          subtitle: Text(
                            '${matchPoll.matchName} - d. ${DateHelper.getFormattedDate(matchPoll.createdAt)}',
                          ),
                          additionalInfo: Text(
                            '${matchPoll.playerOfTheMatchVotes} stemmer',
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
