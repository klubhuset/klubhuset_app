import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/match_poll_row_item.dart';
import 'package:klubhuset/model/match_poll_details.dart';
import 'package:klubhuset/model/player_details.dart';
import 'package:klubhuset/repository/match_polls_repository.dart';
import 'package:klubhuset/model/player_vote.dart';
import 'package:klubhuset/state/player_votes_state.dart';
import 'package:klubhuset/page/match_polls_page.dart';
import 'package:provider/provider.dart';

class CreateMatchPollPage extends StatefulWidget {
  final List<PlayerDetails> squad;
  final List<MatchPollDetails> matchPolls;

  CreateMatchPollPage({required this.squad, required this.matchPolls});

  @override
  State<CreateMatchPollPage> createState() => _CreateMatchPollPageState();
}

class _CreateMatchPollPageState extends State<CreateMatchPollPage> {
  late TextEditingController _matchNameController;

  @override
  void initState() {
    super.initState();
    _matchNameController = TextEditingController();
  }

  @override
  void dispose() {
    _matchNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var playerVotes = context.watch<PlayerVotesState>().playerVotes;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Ny afstemning'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              await createMatchPoll(context, playerVotes);

              if (context.mounted) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => MatchPollsListPage()),
                );
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
                          placeholder: 'F.eks. Skjold mod Frem',
                          validator: (String? value) =>
                              validateNameOfMatchInput(value),
                          keyboardType: TextInputType.name,
                          controller: _matchNameController,
                          maxLength: 255,
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

  String? validateNameOfMatchInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Indtast navnet på kampen';
    }

    return null;
  }

  Future<void> createMatchPoll(
      BuildContext context, List<PlayerVote> playerVotes) async {
    bool doesMatchNameAlreadyExists = widget.matchPolls.any((x) =>
        x.matchName.toLowerCase() == _matchNameController.text.toLowerCase());

    if (doesMatchNameAlreadyExists) {
      // Show CupertinoDialog if match name exists
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text(
              'Afstemning til kampen eksisterer allerede. Ændr navnet på kampen'),
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
      return;
    }

    if (playerVotes.isEmpty) {
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
      return;
    }

    // Sort list of player votes based on highest number of vores
    PlayerVote playerVoteWithMostVotes =
        playerVotes.reduce((a, b) => a.votes > b.votes ? a : b);

    int playerOfTheMatchId = playerVoteWithMostVotes.playerId;
    int numberOfVotes = playerVoteWithMostVotes.votes;

    await MatchPollsRepository.createMatchPoll(
        _matchNameController.text, playerOfTheMatchId, numberOfVotes);

    Provider.of<PlayerVotesState>(context, listen: false)
        .removeAllPlayerVotes();
  }

  List<MatchPollRowItem> getMatchPollRowItems() {
    List<MatchPollRowItem> matchPollRowItems = [];

    for (var player in widget.squad) {
      var matchPollItem =
          MatchPollRowItem(playerId: player.id, playerName: player.name);

      matchPollRowItems.add(matchPollItem);
    }

    return matchPollRowItems;
  }
}
