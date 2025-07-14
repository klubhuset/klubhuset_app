import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/component/match_poll_row_item.dart';
import 'package:klubhuset/helpers/date_helper.dart';
import 'package:klubhuset/model/match_details.dart';
import 'package:klubhuset/model/match_poll_details.dart';
import 'package:klubhuset/model/user_details.dart';
import 'package:klubhuset/page/match_polls/create_match_poll_page.dart';
import 'package:klubhuset/page/team_fines/team_fines_page.dart';
import 'package:klubhuset/repository/match_repository.dart';
import 'package:klubhuset/repository/users_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum MatchDetailsSegments { info, statistics, manOfTheMatch, fines }

class MatchDetailsPage extends StatefulWidget {
  final int matchId;

  MatchDetailsPage({required this.matchId});

  @override
  State<MatchDetailsPage> createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  late Future<Map<String, dynamic>> matchAndSquadData;
  bool _isManOfTheMatchVoted = false;
  MatchPollDetails? matchPollDetails;

  MatchDetailsSegments _selectedSegment = MatchDetailsSegments.info;

  @override
  void initState() {
    super.initState();

    matchAndSquadData = _fetchMatchAndSquad();
  }

  Future<Map<String, dynamic>> _fetchMatchAndSquad() async {
    // Fetching both matchPolls and squad data
    final squad = await UsersRepository.getSquad();
    final matchDetails = await MatchRepository.getMatch(widget.matchId);

    if (matchDetails.matchPollDetails != null) {
      _setMatchPollDetails(matchDetails.matchPollDetails);
    }

    // Combine the two into one map
    return {
      'squad': squad,
      'matchDetails': matchDetails,
    };
  }

  void _setMatchPollDetails(MatchPollDetails? matchPollDetailsToSet) {
    _isManOfTheMatchVoted = true;

    matchPollDetails = matchPollDetailsToSet;
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
                  Navigator.of(context).pop();
                },
                child: Icon(
                  semanticLabel: 'Tilbage',
                  CupertinoIcons.chevron_left,
                )),
            middle: Text('Kampdetaljer'),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: FutureHandler<Map<String, dynamic>>(
                future: matchAndSquadData,
                noDataFoundMessage: 'Ingen kamp fundet.',
                onSuccess: (context, data) {
                  final matchDetails = data['matchDetails'] as MatchDetails;
                  final squad = data['squad'] as List<UserDetails>;

                  return Column(
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.all(20.0),
                          padding: const EdgeInsets.all(20.0),
                          height: 100,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBackground,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  // TODO: Display the match name with result
                                  matchDetails.matchName,
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              _buildActionButtonsOverview()
                              // CupertinoButton(
                              //   padding: EdgeInsets.zero,
                              //   onPressed: () {
                              //     Navigator.of(context).push(
                              //         MaterialWithModalsPageRoute(
                              //             builder: (context) =>
                              //                 TeamFinesPage()));
                              //   },
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       color: CupertinoColors.systemIndigo,
                              //       borderRadius: BorderRadius.circular(50.0),
                              //     ),
                              //     padding: EdgeInsets.symmetric(
                              //         vertical: 15.0, horizontal: 30.0),
                              //     child: Text(
                              //       'Gå til Bødekassen',
                              //       style: TextStyle(
                              //         color: CupertinoColors.white,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 380,
                                child: CupertinoSlidingSegmentedControl<
                                    MatchDetailsSegments>(
                                  backgroundColor: CupertinoColors.systemGrey2,
                                  // This represents the currently selected segmented control.
                                  groupValue: _selectedSegment,
                                  // Callback that sets the selected segmented control.
                                  onValueChanged:
                                      (MatchDetailsSegments? value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedSegment = value;
                                      });
                                    }
                                  },
                                  children: const <MatchDetailsSegments,
                                      Widget>{
                                    MatchDetailsSegments.info: Text(
                                      'Info',
                                      style: TextStyle(
                                          color: CupertinoColors.black,
                                          fontSize: 13),
                                    ),
                                    MatchDetailsSegments.statistics: Text(
                                      'Statistik',
                                      style: TextStyle(
                                          color: CupertinoColors.black,
                                          fontSize: 13),
                                    ),
                                    MatchDetailsSegments.manOfTheMatch: Text(
                                      'MVP',
                                      style: TextStyle(
                                          color: CupertinoColors.black,
                                          fontSize: 13),
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(child: getMatchDetailSegment(matchDetails, squad)),
                    ],
                  );
                },
              ),
            ),
          ),
        ));
  }

  Widget getMatchDetailSegment(
      MatchDetails matchDetails, List<UserDetails> squad) {
    if (_selectedSegment == MatchDetailsSegments.info) {
      return Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Text('Kampdetaljer',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(DateHelper.getFormattedDate(matchDetails.date),
                            style: TextStyle(fontSize: 15)),
                        SizedBox(height: 5),
                        Text(DateHelper.getFormattedTime(matchDetails.date),
                            style: TextStyle(fontSize: 15)),
                        SizedBox(height: 5),
                        Text(matchDetails.location,
                            style: TextStyle(fontSize: 15)),
                        SizedBox(height: 5),
                      ],
                    ),
                  )),
            ],
          ));
    } else if (_selectedSegment == MatchDetailsSegments.manOfTheMatch) {
      return Container(
        margin: const EdgeInsets.all(20.0),
        padding: EdgeInsets.only(top: 20, bottom: 20),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isManOfTheMatchVoted &&
                  matchPollDetails!.matchPollUserVotesDetails.isNotEmpty) ...[
                // Votes for MOTM
                CupertinoListSection(
                    header: const Text('Stemmer'),
                    topMargin: 0,
                    margin: EdgeInsets.zero,
                    backgroundColor: CupertinoColors.systemBackground,
                    children: getMatchPollRowItems(squad)),
              ] else ...[
                Text('Ingen afstemning endnu', style: TextStyle(fontSize: 15)),
                SizedBox(height: 20),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    final data = await matchAndSquadData;
                    final squad = data['squad'] as List<UserDetails>;
                    final matchDetails = data['matchDetails'] as MatchDetails;

                    if (mounted) {
                      final result = await showCupertinoModalBottomSheet(
                        expand: true,
                        context: context,
                        builder: (context) => CreateMatchPollPage(
                          squad: squad,
                          matches: [matchDetails],
                        ),
                      );

                      if (result != null) {
                        _setMatchPollDetails(result);
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemIndigo,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    child: Text(
                      'Stem på kampens spiller',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return Text('Kommer snart!');
  }

  Widget _buildActionButtonsOverview() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getButtonItem('Tilmelding', CupertinoIcons.arrow_down_square),
            SizedBox(width: 30),
            getButtonItem('Bødekassen', CupertinoIcons.money_dollar,
                onTap: () async {}),
          ],
        ),
      ),
    );
  }

  Widget getButtonItem(String buttonText, IconData buttonIcon,
      {Function()? onTap}) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Column(
          children: [
            Icon(buttonIcon, color: CupertinoColors.black, size: 24),
            SizedBox(height: 8),
            Text(
              buttonText,
              style: TextStyle(
                  color: CupertinoColors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  List<MatchPollRowItem> getMatchPollRowItems(List<UserDetails> squad) {
    var matchPollRowItems = matchPollDetails!.matchPollUserVotesDetails
        .map((matchPollUserVotes) => MatchPollRowItem(
            disabled: true,
            userId: matchPollUserVotes.userId,
            userName: squad
                .firstWhere(
                    (element) => element.id == matchPollUserVotes.userId)
                .name,
            votes: matchPollUserVotes.numberOfVotes,
            isUserPlayerOfTheMatch:
                matchPollDetails!.playerOfTheMatchDetails.id ==
                    matchPollUserVotes.userId))
        .toList();

    matchPollRowItems.sort((a, b) => b.votes.compareTo(a.votes));

    return matchPollRowItems;
  }
}
