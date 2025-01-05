import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/helpers/date_helper.dart';
import 'package:klubhuset/model/match_details.dart';
import 'package:klubhuset/page/create_match_page.dart';
import 'package:klubhuset/repository/match_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MatchProgrammePage extends StatefulWidget {
  @override
  State<MatchProgrammePage> createState() => _MatchProgrammePageState();
}

class _MatchProgrammePageState extends State<MatchProgrammePage> {
  late Future<List<MatchDetails>> matches;

  @override
  void initState() {
    super.initState();
    matches = MatchRepository.getMatches();
  }

  Future<void> _refreshMatches() async {
    setState(() {
      matches = MatchRepository.getMatches();
    });
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
                  Navigator.of(context)
                      .popUntil((route) => route.settings.name == '/');
                },
                child: Icon(
                  semanticLabel: 'Tilbage',
                  CupertinoIcons.chevron_left,
                )),
            middle: Text('Kampprogram'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                final data = await matches;

                if (context.mounted) {
                  final result = await showCupertinoModalBottomSheet(
                    expand: true,
                    context: context,
                    builder: (context) => CreateMatchPage(
                      matches: data,
                    ),
                  );

                  if (result == true) {
                    _refreshMatches();
                  }
                }
              },
              child: Icon(
                CupertinoIcons.add,
                semanticLabel: 'Opret kamp',
              ),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: FutureHandler<List<MatchDetails>>(
                future: matches,
                noDataFoundMessage: 'Ingen kampe fundet.',
                onSuccess: (context, data) {
                  // If data is available, build the list
                  return CupertinoListSection.insetGrouped(
                    dividerMargin: 0,
                    additionalDividerMargin: 0,
                    children: List.generate(
                      data.length,
                      (index) {
                        final matchDetails = data[index];

                        return CupertinoListTile(
                            title: Text(matchDetails.name),
                            subtitle: Text(
                              'D. ${DateHelper.getFormattedDate(matchDetails.matchDate)}',
                            ));
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
