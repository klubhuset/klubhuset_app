import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klubhuset/component/button/button.dart';
import 'package:klubhuset/component/button/button_small.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/component/match_poll_row_item.dart';
import 'package:klubhuset/helpers/date_helper.dart';
import 'package:klubhuset/model/match_details.dart';
import 'package:klubhuset/model/match_poll_details.dart';
import 'package:klubhuset/model/user_details.dart';
import 'package:klubhuset/page/match_polls/create_match_poll_page.dart';
import 'package:klubhuset/repository/authentication_repository.dart';
import 'package:klubhuset/repository/match_repository.dart';
import 'package:klubhuset/repository/users_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum MatchDetailsSegments { registration, statistics, manOfTheMatch, fines }

enum _PickRole { scorer, assist }

class _GoalDraft {
  int? scorerId;
  int? assistId;
  _GoalDraft({this.scorerId, this.assistId});
}

class MatchDetailsPage extends StatefulWidget {
  final int matchId;

  MatchDetailsPage({required this.matchId});

  @override
  State<MatchDetailsPage> createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  late Future<Map<String, dynamic>> matchAndSquadData;
  late Future<UserDetails> currentUserData;
  bool _isManOfTheMatchVoted = false;
  MatchPollDetails? matchPollDetails;
  int _homeGoals = 0;
  int _awayGoals = 0;

  MatchDetailsSegments _selectedSegment = MatchDetailsSegments.registration;

  @override
  void initState() {
    super.initState();

    matchAndSquadData = _fetchMatchAndSquad();
    currentUserData = AuthenticationRepository.getCurrentUser();
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

                  // Use FutureHandler for currentUserData
                  return FutureHandler<UserDetails>(
                    future: currentUserData,
                    noDataFoundMessage: 'Ingen bruger fundet.',
                    onSuccess: (context, currentUser) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20.0),
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemBackground,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        matchDetails.homeTeam,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    if (currentUser.isTeamOwner &&
                                        !matchDetails.hasMatchBeenPlayed)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: ButtonSmall(
                                          buttonText: 'Indberet',
                                          onPressed: () async {
                                            setMatchScore(matchDetails.id);
                                          },
                                          outlined: true,
                                        ),
                                      )
                                    else if (!matchDetails.hasMatchBeenPlayed)
                                      Text(
                                        '-',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      )
                                    else
                                      Text(
                                        '${matchDetails.homeTeamScore} - ${matchDetails.awayTeamScore}',
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    Expanded(
                                      child: Text(
                                        matchDetails.awayTeam,
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                const _LabeledDivider(label: 'Detaljer'),
                                const SizedBox(height: 30),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final double chipMax =
                                        (constraints.maxWidth - 10) / 2;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            _InfoPill(
                                              icon: CupertinoIcons.calendar,
                                              text: DateHelper.getFormattedDate(
                                                  matchDetails.date),
                                              maxWidth: chipMax,
                                            ),
                                            _InfoPill(
                                              icon: CupertinoIcons.time,
                                              text:
                                                  '${DateHelper.getFormattedTime(matchDetails.date)} (${DateHelper.getFormattedTime(matchDetails.meetingTime)})',
                                              maxWidth: chipMax,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        _InfoBar(
                                          icon: CupertinoIcons.location_solid,
                                          text: matchDetails.location,
                                          maxWidth: constraints.maxWidth,
                                        ),
                                        const SizedBox(height: 12),
                                        _InfoBar(
                                            icon: CupertinoIcons.pencil,
                                            text: matchDetails.notes ??
                                                'Ingen noter',
                                            maxWidth: constraints.maxWidth),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 380,
                                    child: CupertinoSlidingSegmentedControl<
                                        MatchDetailsSegments>(
                                      backgroundColor:
                                          CupertinoColors.systemGrey2,
                                      groupValue: _selectedSegment,
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
                                        MatchDetailsSegments.manOfTheMatch:
                                            Text(
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
                          // Pass currentUser if needed to getMatchDetailSegment
                          Center(
                              child:
                                  getMatchDetailSegment(matchDetails, squad)),
                        ],
                      );
                    },
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
                      'Tilmeldte - ${matchDetails.matchRegistrationDetailsList!.where((matchRegistrationDetails) => matchRegistrationDetails.isUserParticipating).length}',
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
                Button(
                    buttonText: 'Stem på kampens spiller',
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

                        if (result == true) {
                          _setMatchPollDetails(result);
                        }
                      }
                    }),
              ],
            ],
          ),
        ),
      );
    } else if (_selectedSegment == MatchDetailsSegments.statistics) {
      return Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: ButtonSmall(
            buttonText: 'Tilføj statistik',
            onPressed: () async {
              addGoalscorer();
            },
            outlined: true,
            icon: CupertinoIcons.add,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text('Funktionaliteten kommer snart!',
            style: TextStyle(fontSize: 15)),
      ),
    );
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

  Future<void> setMatchScore(int matchDetailsId) async {
    final outerContext = context;

    int tempHome = _homeGoals;
    int tempAway = _awayGoals;

    final homeCtl = TextEditingController(text: tempHome.toString());
    final awayCtl = TextEditingController(text: tempAway.toString());
    final homeNode = FocusNode();
    final awayNode = FocusNode();

    bool isSaving = false; // <-- flyttet hertil, så det bevares over rebuilds

    await showCupertinoModalPopup(
      context: outerContext,
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            bool valid(String v) {
              if (v.isEmpty) return false;
              final n = int.tryParse(v);
              return n != null && n >= 0 && n <= 999;
            }

            final canSave = valid(homeCtl.text) && valid(awayCtl.text);

            Future<void> onOk() async {
              if (!canSave || isSaving) return;

              final h = int.parse(homeCtl.text);
              final a = int.parse(awayCtl.text);

              setModalState(() => isSaving = true);
              try {
                // 🔗 Brug de NYE værdier h/a (ikke de gamle felter)
                await MatchRepository.updateMatchScore(matchDetailsId, h, a);

                if (!mounted) return;

                // Opdater UI lokalt
                setState(() {
                  _homeGoals = h;
                  _awayGoals = a;
                });

                _refreshMatchAndSquad();

                Navigator.of(modalContext).pop(); // luk modal
              } catch (e) {
                setModalState(() => isSaving = false);
                showCupertinoDialog(
                  context: modalContext,
                  builder: (_) => CupertinoAlertDialog(
                    title: const Text('Kunne ikke gemme'),
                    content: Text('$e'),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('OK'),
                        onPressed: () => Navigator.of(modalContext).pop(),
                      ),
                    ],
                  ),
                );
              }
            }

            return Container(
              color: CupertinoColors.systemBackground.resolveFrom(modalContext),
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MediaQuery.removePadding(
                        context: modalContext,
                        removeTop: true,
                        child: CupertinoNavigationBar(
                          middle: const Text('Indtast resultat'),
                          leading: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Text('Annullér'),
                            onPressed: () => Navigator.of(modalContext).pop(),
                          ),
                          trailing: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: canSave && !isSaving ? onOk : null,
                            child: isSaving
                                ? const CupertinoActivityIndicator()
                                : Text(
                                    'OK',
                                    style: TextStyle(
                                      color: canSave
                                          ? CupertinoColors.activeBlue
                                          : CupertinoColors.inactiveGray,
                                    ),
                                  ),
                          ),
                          border: const Border(
                            bottom: BorderSide(
                              color: CupertinoColors.separator,
                              width: 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: CupertinoTextField(
                                controller: homeCtl,
                                focusNode: homeNode,
                                autofocus: true,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                placeholder: 'Hjemme mål',
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                onChanged: (_) => setModalState(() {}),
                                onSubmitted: (_) => awayNode.requestFocus(),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('—', style: TextStyle(fontSize: 20)),
                            ),
                            Expanded(
                              child: CupertinoTextField(
                                controller: awayCtl,
                                focusNode: awayNode,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                placeholder: 'Ude mål',
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                onChanged: (_) => setModalState(() {}),
                                onSubmitted: (_) => onOk(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          child: Text(
                            'Kun hele tal (0–999).',
                            style: TextStyle(
                              fontSize: 12,
                              color: CupertinoColors.secondaryLabel
                                  .resolveFrom(modalContext),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    homeCtl.dispose();
    awayCtl.dispose();
    homeNode.dispose();
    awayNode.dispose();
  }

  Future<void> addGoalscorer() async {
    final data = await matchAndSquadData;
    final squad = (data['squad'] as List<UserDetails>);

    _PickRole activeRole = _PickRole.scorer;
    _GoalDraft current = _GoalDraft();
    bool noAssist = false;

    final List<_GoalDraft> staged = [];
    String query = '';
    bool isSaving = false;

    List<UserDetails> filtered() {
      if (query.trim().isEmpty) return squad;
      final q = query.trim().toLowerCase();
      return squad.where((u) => u.name.toLowerCase().contains(q)).toList();
    }

    String nameOf(int? id) =>
        id == null ? '-' : squad.firstWhere((u) => u.id == id).name;

    bool draftValid(_GoalDraft d) =>
        d.scorerId != null && (noAssist || d.assistId != null);

    void resetCurrent(StateSetter setModalState) {
      setModalState(() {
        current = _GoalDraft();
        noAssist = false;
        activeRole = _PickRole.scorer;
        query = '';
      });
    }

    await showCupertinoModalPopup(
      context: context,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            Future<void> addToList() async {
              if (!draftValid(current)) return;
              setModalState(() {
                staged.add(_GoalDraft(
                  scorerId: current.scorerId,
                  assistId: noAssist ? null : current.assistId,
                ));
              });
              resetCurrent(setModalState);
            }

            Future<void> saveAll() async {
              if (staged.isEmpty || isSaving) return;
              setModalState(() => isSaving = true);
              try {
                for (final d in staged) {
                  // await MatchRepository.addGoalEvent(
                  //   matchId: widget.matchId,
                  //   scorerUserId: d.scorerId!,
                  //   assistUserId: d.assistId,
                  // );
                }
                if (!mounted) return;
                await _refreshMatchAndSquad();
                Navigator.of(modalContext).pop();
              } catch (e) {
                setModalState(() => isSaving = false);
                showCupertinoDialog(
                  context: modalContext,
                  builder: (_) => CupertinoAlertDialog(
                    title: const Text('Kunne ikke gemme'),
                    content: Text('$e'),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('OK'),
                        onPressed: () => Navigator.of(modalContext).pop(),
                      ),
                    ],
                  ),
                );
              }
            }

            void selectUser(UserDetails u) {
              setModalState(() {
                if (activeRole == _PickRole.scorer) {
                  current.scorerId = u.id;
                } else {
                  current.assistId = u.id;
                  noAssist = false;
                }
              });
            }

            final mq = MediaQuery.of(modalContext);
            final maxSheetHeight =
                (mq.size.height - mq.viewInsets.bottom) * 0.9;

            return Container(
              color: CupertinoColors.systemBackground.resolveFrom(modalContext),
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: maxSheetHeight,
                    child: Column(
                      children: [
                        // Topbar (fast)
                        MediaQuery.removePadding(
                          context: modalContext,
                          removeTop: true,
                          child: CupertinoNavigationBar(
                            middle: Text('Tilføj målscorer'),
                            leading: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Text('Luk'),
                              onPressed: () => Navigator.of(modalContext).pop(),
                            ),
                            trailing: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: (!isSaving && staged.isNotEmpty)
                                  ? saveAll
                                  : null,
                              child: isSaving
                                  ? const CupertinoActivityIndicator()
                                  : Text(
                                      'Gem',
                                      style: TextStyle(
                                        color: staged.isNotEmpty
                                            ? CupertinoColors.activeBlue
                                            : CupertinoColors.inactiveGray,
                                      ),
                                    ),
                            ),
                            border: const Border(
                              bottom: BorderSide(
                                  color: CupertinoColors.separator, width: 0),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
                          child: Column(
                            children: [
                              CupertinoSlidingSegmentedControl<_PickRole>(
                                groupValue: activeRole,
                                children: const {
                                  _PickRole.scorer: Text('Vælg målscorer',
                                      style: TextStyle(fontSize: 15)),
                                  _PickRole.assist: Text('Vælg assist',
                                      style: TextStyle(fontSize: 15)),
                                },
                                onValueChanged: (v) {
                                  if (v != null)
                                    setModalState(() => activeRole = v);
                                },
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Ingen assist',
                                      style: TextStyle(fontSize: 15)),
                                  const SizedBox(width: 8),
                                  CupertinoSwitch(
                                    value: noAssist,
                                    onChanged: (val) => setModalState(() {
                                      noAssist = val;
                                      if (noAssist) current.assistId = null;
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(8, 10, 8, 4),
                                child: Text('Vælg spiller',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filtered().length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1, thickness: 0.6),
                                itemBuilder: (_, idx) {
                                  final u = filtered()[idx];
                                  final isScorer = current.scorerId == u.id;
                                  final isAssist = current.assistId == u.id;

                                  return CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    minSize: 50,
                                    onPressed: () => selectUser(u),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              u.name,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isScorer)
                                            const Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: _Badge(label: 'Scorer'),
                                            ),
                                          if (isAssist)
                                            const Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: _Badge(label: 'Assist'),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(8, 10, 8, 4),
                                child: Text('Tilføjede målscorer',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              if (staged.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                ListView.builder(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: staged.length,
                                  itemBuilder: (_, i) {
                                    final d = staged[i];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemGrey6,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: CupertinoColors.separator),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                              '${nameOf(d.scorerId)}  —  ${d.assistId == null ? "Ingen assist" : nameOf(d.assistId)}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 15)),
                                          const Spacer(),
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            minSize: 0,
                                            onPressed: () => setModalState(
                                                () => staged.removeAt(i)),
                                            child: const Icon(
                                                CupertinoIcons.delete,
                                                color: CupertinoColors
                                                    .destructiveRed),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ] else ...[
                                const SizedBox(height: 20),
                                const Center(
                                  child: Text(
                                    'Ingen mål tilføjet endnu',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Bund-knap (altid synlig, disablet når invalid)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: Button(
                            buttonText: 'Tilføj til liste',
                            onPressed: () => addToList(),
                            enabled: draftValid(current),
                            icon: CupertinoIcons.add,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _LabeledDivider extends StatelessWidget {
  final String label;
  const _LabeledDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    final text = Text(label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));
    return Row(
      children: [
        const Expanded(child: Divider()),
        const SizedBox(width: 12),
        text,
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final double? maxWidth;

  const _InfoPill({
    required this.icon,
    required this.text,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? 240),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey[800]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 14, height: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBar extends StatelessWidget {
  final IconData icon;
  final String text;
  final double? maxWidth;

  const _InfoBar({
    required this.icon,
    required this.text,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? 480),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[800]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, height: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: CupertinoColors.separator, width: 0.5),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: CupertinoColors.black),
      ),
    );
  }
}
