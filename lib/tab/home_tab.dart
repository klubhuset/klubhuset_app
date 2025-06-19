import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubhuset/page/match_polls/match_polls_page.dart';
import 'package:klubhuset/page/match_programme/match_programme.dart';
import 'package:klubhuset/page/team/team_page.dart';
import 'package:klubhuset/page/team_fines/team_fines_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Container for match programme
              CupertinoButton(
                child: Container(
                  height: 100,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(46, 134, 171, 100),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Kampprogram',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialWithModalsPageRoute(
                      builder: (context) => MatchProgrammePage()));
                },
              ),

              // Container for Man-of-the-match
              CupertinoButton(
                child: Container(
                  height: 100,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(38, 64, 139, 100),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Kampens spiller',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialWithModalsPageRoute(
                      builder: (context) => MatchPollsListPage()));
                },
              ),

              // Container for the Squad
              CupertinoButton(
                child: Container(
                  height: 100,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(224, 159, 62, 100),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Truppen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialWithModalsPageRoute(
                      builder: (context) => TeamPage()));
                },
              ),

              // Container for Team Fines
              CupertinoButton(
                child: Container(
                  height: 100,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(166, 117, 161, 100),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Bødekassen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialWithModalsPageRoute(
                      builder: (context) => TeamFinesPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
