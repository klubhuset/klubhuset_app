import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/helpers/date_helper.dart';
import 'package:klubhuset/model/match_details.dart';
import 'package:klubhuset/model/match_poll_details.dart';
import 'package:klubhuset/model/player_details.dart';
import 'package:klubhuset/page/create_match_poll_page.dart';
import 'package:klubhuset/repository/match_repository.dart';
import 'package:klubhuset/repository/players_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum MatchDetailsSegments { info, manOfTheMatch, fines }

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
    final squad = await PlayersRepository.getSquad();
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

                  return Column(
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          padding: const EdgeInsets.all(20.0),
                          width: 350,
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
                                  matchDetails.name,
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 350,
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
                                      'INFO',
                                      style: TextStyle(
                                          color: CupertinoColors.black,
                                          fontSize: 13),
                                    ),
                                    MatchDetailsSegments.manOfTheMatch: Text(
                                      'MOTM',
                                      style: TextStyle(
                                          color: CupertinoColors.black,
                                          fontSize: 13),
                                    ),
                                    MatchDetailsSegments.fines: Text(
                                      'BØDER',
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
                      Center(child: getMatchDetailSegment(matchDetails)),
                    ],
                  );
                },
              ),
            ),
          ),
        ));
  }

  Widget getMatchDetailSegment(MatchDetails matchDetails) {
    if (_selectedSegment == MatchDetailsSegments.info) {
      return Container(
        margin: const EdgeInsets.only(top: 20.0),
        padding: const EdgeInsets.all(20.0),
        width: 350,
        height: 160,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 15),
              Text(DateHelper.getFormattedDate(matchDetails.matchDate),
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 5),
              Text('13:00', style: TextStyle(fontSize: 15)),
              SizedBox(height: 5),
              Text('Lundehusparken', style: TextStyle(fontSize: 15)),
              SizedBox(height: 5),
              Text('Mødetid: 12:30', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      );
    } else if (_selectedSegment == MatchDetailsSegments.manOfTheMatch) {
      return Container(
        margin: const EdgeInsets.only(top: 20.0),
        padding: const EdgeInsets.all(20.0),
        width: 350,
        height: 160,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isManOfTheMatchVoted &&
                  matchPollDetails!.matchPollPlayerVotesDetails.isNotEmpty) ...[
                // TODO: Add for each element in matchPollPlayerVotesDetails
                Text(
                  'Test',
                  style: TextStyle(fontSize: 15),
                ),
              ] else ...[
                Text('Ingen afstemning endnu', style: TextStyle(fontSize: 15)),
                SizedBox(height: 20),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    final data = await matchAndSquadData;
                    final squad = data['squad'] as List<PlayerDetails>;
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
    return Text('');
  }
}
