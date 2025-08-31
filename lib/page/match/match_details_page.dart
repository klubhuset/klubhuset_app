import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/component/match_poll_row_item.dart';
import 'package:klubhuset/helpers/date_helper.dart';
import 'package:klubhuset/model/match_details.dart';
import 'package:klubhuset/model/match_poll_details.dart';
import 'package:klubhuset/model/user_details.dart';
import 'package:klubhuset/page/match_polls/create_match_poll_page.dart';
import 'package:klubhuset/repository/match_repository.dart';
import 'package:klubhuset/repository/users_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum MatchDetailsSegments { registration, statistics, manOfTheMatch, fines }

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

  MatchDetailsSegments _selectedSegment = MatchDetailsSegments.registration;

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

  Future<void> _refreshMatchAndSquad() async {
    setState(() {
      matchAndSquadData = _fetchMatchAndSquad();
    });
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
                                SizedBox(height: 30),
                                Text('Detaljer',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text(
                                    DateHelper.getFormattedDate(
                                        matchDetails.date),
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(height: 5),
                                Text(
                                    DateHelper.getFormattedTime(
                                        matchDetails.date),
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(height: 5),
                                Text(matchDetails.location,
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                                    MatchDetailsSegments.registration: Text(
                                      'Tilmelding',
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
    if (_selectedSegment == MatchDetailsSegments.registration) {
      return Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildActionButtonsInfo(matchDetails),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: CupertinoColors.systemBackground,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tilmeldte (${matchDetails.matchRegistrationDetailsList!.where((matchRegistrationDetails) => matchRegistrationDetails.isUserParticipating).length})',
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (matchDetails.matchRegistrationDetailsList!
                        .where((matchRegistrationDetails) =>
                            matchRegistrationDetails.isUserParticipating)
                        .isNotEmpty)
                      const SizedBox(height: 10),
                    ...matchDetails.matchRegistrationDetailsList!
                        .where((d) => d.isUserParticipating)
                        .map((d) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                d.userDetails.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: CupertinoColors.systemBackground,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Frameldte - ${matchDetails.matchRegistrationDetailsList!.where((matchRegistrationDetails) => !matchRegistrationDetails.isUserParticipating).length}',
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...matchDetails.matchRegistrationDetailsList!
                        .where((d) => !d.isUserParticipating)
                        .map((d) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                d.userDetails.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: CupertinoColors.systemBackground,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ej tilkendegivet - ${squad.where((player) => !matchDetails.matchRegistrationDetailsList!.any((registration) => registration.userDetails.id == player.id)).length}',
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (squad
                        .where((player) => !matchDetails
                            .matchRegistrationDetailsList!
                            .any((registration) =>
                                registration.userDetails.id == player.id))
                        .isNotEmpty)
                      const SizedBox(height: 10),
                    ...squad
                        .where((player) => !matchDetails
                            .matchRegistrationDetailsList!
                            .any((registration) =>
                                registration.userDetails.id == player.id))
                        .map((d) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                d.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            )),
                  ],
                ),
              )
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

  Widget _buildActionButtonsInfo(MatchDetails matchDetails) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getButtonItem(
              'Tilmeld',
              CupertinoIcons.add_circled,
              CupertinoColors.systemGreen,
              CupertinoColors.white,
              onTap: () async {
                var hasUserRegisteredForMatch = await registerForMatch();

                if (hasUserRegisteredForMatch) {
                  _refreshMatchAndSquad();
                }
              },
            ),
            SizedBox(width: 30),
            getButtonItem(
              'Afmeld',
              CupertinoIcons.minus_circle,
              CupertinoColors.systemRed,
              CupertinoColors.white,
              onTap: () async {
                var hasUnregisteredFromMatch = await unregisterFromMatch();

                if (hasUnregisteredFromMatch) {
                  _refreshMatchAndSquad();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getButtonItem(String buttonText, IconData buttonIcon,
      Color backgroundColor, Color textColor,
      {Function()? onTap}) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 100,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Column(
          children: [
            Icon(buttonIcon, color: textColor, size: 24),
            SizedBox(height: 8),
            Text(
              buttonText,
              style: TextStyle(
                  color: textColor, fontSize: 13, fontWeight: FontWeight.bold),
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

  Future<bool> registerForMatch() async {
    var matchRegistration =
        await MatchRepository.registerForMatch(widget.matchId);

    return matchRegistration > 0;
  }

  Future<bool> unregisterFromMatch() async {
    var matchRegistration =
        await MatchRepository.unregisterFromMatch(widget.matchId);

    return matchRegistration > 0;
  }
}
