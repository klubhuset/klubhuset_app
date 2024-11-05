import 'package:flutter/cupertino.dart';
import 'package:klubhuset/pages/match_polls_list_page.dart';

class MatchPollPage extends StatefulWidget {
  const MatchPollPage({super.key});

  @override
  State<MatchPollPage> createState() => _MatchPollPageState();
}

class _MatchPollPageState extends State<MatchPollPage> {
  late TextEditingController _textController;

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
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Ny afstemning'),
          trailing: GestureDetector(
              onTap: () => {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => MatchPollsListPage()),
                    )
                  },
              child: Text('Gem',
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
                          placeholder: 'Indtast navn på kampen',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Indtast navnet på kampen';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                        )
                      ])),

              // Vote on the player of the match
              CupertinoListSection(
                  header: const Text('Stem på kampens spiller'),
                  children: <CupertinoListTile>[
                    CupertinoListTile.notched(
                        title: const Text('Anders H. Brandt'),
                        trailing: SizedBox(
                          width: 100,
                          child: CupertinoTextField(
                              maxLength: 1000,
                              decoration: new BoxDecoration(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              keyboardType: TextInputType.numberWithOptions(),
                              controller: _textController,
                              textAlign: TextAlign.center),
                        )

                        // CupertinoButton(
                        //     padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        //     color: CupertinoColors.lightBackgroundGray,
                        //     child: Text('${_selectedValue}',
                        //         style: new TextStyle(
                        //             color: CupertinoColors.black)),
                        //     onPressed: () => showCupertinoModalPopup(
                        //         context: context,
                        //         builder: (_) => SizedBox(
                        //               width: double.infinity,
                        //               height: 250,
                        //               child: CupertinoPicker(
                        //                   backgroundColor:
                        //                       CupertinoColors.white,
                        //                   itemExtent:
                        //                       30, // TODO: Should be based on number of players in the team
                        //                   scrollController:
                        //                       FixedExtentScrollController(
                        //                           initialItem: 1),
                        //                   onSelectedItemChanged: (int value) {},
                        //                   children: const [
                        //                     // TODO: Should be based on number of players in the team
                        //                     Text('0'),
                        //                     Text('1'),
                        //                     Text('3'),
                        //                     Text('4')
                        //                   ]),
                        //             ))

                        //             )
                        ),
                  ]),
            ],
          ),
        )));
  }
}
