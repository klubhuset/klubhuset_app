import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/match_poll_row_item.dart';
import 'package:klubhuset/model/create_match_poll_command.dart';
import 'package:klubhuset/model/match_poll_details.dart';
import 'package:klubhuset/state/match_polls_state.dart';
import 'package:klubhuset/model/player_vote.dart';
import 'package:klubhuset/state/player_votes_state.dart';
import 'package:klubhuset/page/match_polls_page.dart';
import 'package:provider/provider.dart';

class CreateMatchPollPage extends StatefulWidget {
  @override
  State<CreateMatchPollPage> createState() => _CreateMatchPollPageState();
}

class _CreateMatchPollPageState extends State<CreateMatchPollPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var playerVotes = context.watch<PlayerVotesState>().playerVotes;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Ny afstemning'),
          trailing: GestureDetector(
              onTap: () => createMatchPoll(context, playerVotes),
              child: Text('Opret',
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
                          placeholder: 'F.eks. Skjold mod Frem',
                          validator: (String? value) =>
                              validateNameOfMatchInput(value),
                          keyboardType: TextInputType.name,
                          controller: _textController,
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

  void createMatchPoll(BuildContext context, List<PlayerVote> playerVotes) {
    //TODO 1: Handle if there's not votes and if vores are the same

    List<MatchPollDetails> existingMatchPolls =
        Provider.of<MatchPollsState>(context, listen: false).matchPolls;

    bool doesMatchNameAlreadyExists = existingMatchPolls.any(
        (x) => x.matchName.toLowerCase() == _textController.text.toLowerCase());

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

    CreateMatchPollCommand matchPoll = CreateMatchPollCommand(
        _textController.text, playerOfTheMatchId, numberOfVotes);

    // Create match poll with new endpoint

    // Provider.of<MatchPollsState>(context, listen: false)
    //     .addMatchPoll(matchPoll);

    Provider.of<PlayerVotesState>(context, listen: false)
        .removeAllPlayerVotes();

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => MatchPollsListPage()),
    );
  }

  List<MatchPollRowItem> getMatchPollRowItems() {
    List<MatchPollRowItem> matchPollRowItems = [];

    // TODO 1: Fix this
    // final squad = PlayersRepository.getSquad();

    // for (var player in squad) {
    //   var matchPollItem =
    //       MatchPollRowItem(playerId: player.id, playerName: player.name);

    //   matchPollRowItems.add(matchPollItem);
    // }

    return matchPollRowItems;
  }
}
