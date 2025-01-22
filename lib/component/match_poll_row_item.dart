import 'package:flutter/cupertino.dart';
import 'package:klubhuset/state/player_votes_state.dart';
import 'package:klubhuset/model/player_vote.dart';
import 'package:provider/provider.dart';

class MatchPollRowItem extends StatefulWidget {
  final bool disabled;
  final int playerId;
  final String playerName;
  final int votes;
  final bool isPlayerPlayerOfTheMatch;

  const MatchPollRowItem(
      {super.key,
      this.disabled = false,
      required this.playerId,
      required this.playerName,
      this.votes = 0,
      this.isPlayerPlayerOfTheMatch = false});

  @override
  State<MatchPollRowItem> createState() => _MatchPollRowItemState();
}

class _MatchPollRowItemState extends State<MatchPollRowItem> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.votes.toString());

    // Start listening to changes.
    _textController.addListener(createUpdatePlayerVote);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20, right: 20),
        title: Text(widget.playerName),
        subtitle: widget.isPlayerPlayerOfTheMatch == true
            ? Text('Kampens spiller')
            : null,
        trailing: SizedBox(
          width: 100,
          child: CupertinoTextField(
            maxLength: 1000,
            decoration: BoxDecoration(
              color: CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.lightBackgroundGray,
                darkColor: CupertinoColors.black,
              ),
              border: Border(
                top: BorderSide(
                  color: CupertinoDynamicColor.withBrightness(
                    color: Color(0x33000000),
                    darkColor: Color(0x33FFFFFF),
                  ),
                  width: 0.0,
                ),
                bottom: BorderSide(
                  color: CupertinoDynamicColor.withBrightness(
                    color: Color(0x33000000),
                    darkColor: Color(0x33FFFFFF),
                  ),
                  width: 0.0,
                ),
                left: BorderSide(
                  color: CupertinoDynamicColor.withBrightness(
                    color: Color(0x33000000),
                    darkColor: Color(0x33FFFFFF),
                  ),
                  width: 0.0,
                ),
                right: BorderSide(
                  color: CupertinoDynamicColor.withBrightness(
                    color: Color(0x33000000),
                    darkColor: Color(0x33FFFFFF),
                  ),
                  width: 0.0,
                ),
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            keyboardType: TextInputType.numberWithOptions(),
            controller: _textController,
            textAlign: TextAlign.center,
            readOnly: widget.disabled,
          ),
        ));
  }

  void createUpdatePlayerVote() {
    if (_textController.text.isNotEmpty) {
      int votes = int.parse(_textController.text);

      PlayerVote playerVote =
          PlayerVote(playerId: widget.playerId, votes: votes);

      Provider.of<PlayerVotesState>(context, listen: false)
          .addPlayerVote(playerVote);
    }
  }
}
