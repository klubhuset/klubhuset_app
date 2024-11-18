import 'package:flutter/cupertino.dart';

class MatchPollRowItem extends StatefulWidget {
  final int playerId;
  final String playerName;

  const MatchPollRowItem(
      {super.key, required this.playerId, required this.playerName});

  @override
  State<MatchPollRowItem> createState() => _MatchPollRowItemState();
}

class _MatchPollRowItemState extends State<MatchPollRowItem> {
  late TextEditingController _textController;

  // Use playerId

  // Perhaps use onChange on the TextEditingController

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
        title: Text(widget.playerName),
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
              textAlign: TextAlign.center),
        ));
  }
}
