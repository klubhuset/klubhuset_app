import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/match_poll_row_item.dart';
import 'package:klubhuset/model/match_details.dart';
import 'package:klubhuset/model/match_poll_details.dart';
import 'package:klubhuset/model/user_details.dart';
import 'package:klubhuset/repository/match_polls_repository.dart';
import 'package:klubhuset/model/user_vote.dart';
import 'package:klubhuset/state/user_votes_state.dart';
import 'package:provider/provider.dart';

class CreateMatchPollPage extends StatefulWidget {
  final List<UserDetails> squad;
  final List<MatchDetails> matches;
  final List<MatchPollDetails> matchPolls;

  CreateMatchPollPage(
      {required this.squad,
      this.matches = const [],
      this.matchPolls = const []});

  @override
  State<CreateMatchPollPage> createState() => _CreateMatchPollPageState();
}

class _CreateMatchPollPageState extends State<CreateMatchPollPage> {
  int selectedMatchIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userVotes = context.watch<UserVotesState>().userVotes;

    var matchesToBeSelected = widget.matches.map((x) => x.name).toList();

    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: CupertinoNavigationBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context,
                    false); // Return false to indicate no user was added
              },
              child: Icon(
                semanticLabel: 'Annullér',
                CupertinoIcons.clear,
              )),
          middle: Text('Tilføj afstemning'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              var createdMatchPollDetails =
                  await createMatchPoll(context, userVotes);

              if (createdMatchPollDetails != null && context.mounted) {
                Navigator.pop(context, createdMatchPollDetails);
              }
            },
            child: Text('Opret',
                style: TextStyle(
                    color: CupertinoColors.systemIndigo,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: CupertinoFormSection.insetGrouped(children: <Widget>[
                    _DatePickerItem(
                      children: <Widget>[
                        const Text('Kamp'),
                        CupertinoButton(
                          // Display a CupertinoDatePicker in date picker mode.
                          onPressed: () {
                            _showDialog(
                              CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: 32.0,
                                // This sets the initial item.
                                scrollController: FixedExtentScrollController(
                                  initialItem: selectedMatchIndex,
                                ),
                                // This is called when selected item is changed.
                                onSelectedItemChanged:
                                    (dynamic selectedItemIndex) {
                                  setState(() {
                                    selectedMatchIndex = selectedItemIndex;
                                  });
                                },
                                children: List<Widget>.generate(
                                    matchesToBeSelected.length, (int index) {
                                  return Center(
                                      child: Text(matchesToBeSelected[index]));
                                }),
                              ),
                            );
                          },
                          child: Text(matchesToBeSelected[selectedMatchIndex]),
                        ),
                      ],
                    ),
                  ])),

              // Vote on the player of the match
              CupertinoListSection.insetGrouped(
                  dividerMargin: 0,
                  additionalDividerMargin: 0,
                  margin: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 30.0),
                  header: const Text('Stem på kampens spiller'),
                  children: getMatchPollRowItems()),
            ],
          ),
        )));
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          Container(
            height: 250,
            // The Bottom margin is provided to align the popup above the system navigation bar.
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            // Provide a background color for the popup.
            color: CupertinoColors.systemBackground.resolveFrom(context),
            // Use a SafeArea widget to avoid system overlaps.
            child: SafeArea(
              top: false,
              child: child,
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Luk'),
        ),
      ),
    );
  }

  Future<MatchPollDetails?> createMatchPoll(
      BuildContext context, List<UserVote> userVotes) async {
    int matchId = widget.matches[selectedMatchIndex].id;
    bool doesMatchPollAlreadyExistsForMatch =
        widget.matchPolls.any((x) => x.matchId == matchId);

    if (doesMatchPollAlreadyExistsForMatch) {
      // Show CupertinoDialog if match name exists
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text(
              'Afstemning til kampen eksisterer allerede. Vælg en anden kamp.'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );

      return null;
    }

    if (userVotes.isEmpty) {
      // Show CupertinoDialog if there is no votes
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text('Afgiv mindst én stemme for at oprette en afstemning.'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );

      return null;
    }

    int matchPollId =
        await MatchPollsRepository.createMatchPoll(matchId, userVotes);

    Provider.of<UserVotesState>(context, listen: false).removeAllUserVotes();

    return await MatchPollsRepository.getMatchPoll(matchPollId);
  }

  List<MatchPollRowItem> getMatchPollRowItems() {
    List<MatchPollRowItem> matchPollRowItems = [];

    for (var user in widget.squad) {
      var matchPollItem =
          MatchPollRowItem(userId: user.id, userName: user.name);

      matchPollRowItems.add(matchPollItem);
    }

    return matchPollRowItems;
  }
}

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 5.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
