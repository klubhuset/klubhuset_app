import 'package:flutter/cupertino.dart';
import 'package:kopa/state/user_votes_state.dart';
import 'package:kopa/model/user_vote.dart';
import 'package:provider/provider.dart';

class MatchPollRowItem extends StatefulWidget {
  final bool disabled;
  final int userId;
  final String userName;
  final int votes;
  final bool isUserPlayerOfTheMatch;

  const MatchPollRowItem(
      {super.key,
      this.disabled = false,
      required this.userId,
      required this.userName,
      this.votes = 0,
      this.isUserPlayerOfTheMatch = false});

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
    _textController.addListener(createUpdateUserVote);
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
        title: Text(widget.userName),
        subtitle: widget.isUserPlayerOfTheMatch == true
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
              border: Border.all(
                color: CupertinoDynamicColor.withBrightness(
                  color: Color(0x33000000),
                  darkColor: Color(0x33FFFFFF),
                ),
                width: 0.0,
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

  void createUpdateUserVote() {
    if (_textController.text.isNotEmpty) {
      int votes = int.parse(_textController.text);

      UserVote userVote = UserVote(userId: widget.userId, votes: votes);

      Provider.of<UserVotesState>(context, listen: false).addUserVote(userVote);
    }
  }
}
