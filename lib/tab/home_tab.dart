import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubhuset/page/match_polls_page.dart';
import 'package:klubhuset/page/squad_page.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: <Widget>[
        // Container for team name
        Container(
            margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Text('Boldklubben skjold',
                style: const TextStyle(fontSize: 20))),

        // Container for Man-of-the-match
        CupertinoButton(
          child: Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('assets/mindful.jpg'),
              //   fit: BoxFit.cover,
              // ),
              color: Color.fromRGBO(38, 64, 139, 100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              //margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
              child: const Center(
                  child: Text(
                "Kampens spiller",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => MatchPollsListPage()),
            );
          },
        ),

        // Container for the Squad
        CupertinoButton(
          child: Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('assets/mindful.jpg'),
              //   fit: BoxFit.cover,
              // ),
              //color: Color.fromRGBO(38, 64, 139, 100),
              color: Color.fromRGBO(224, 159, 62, 100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              //margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
              child: const Center(
                  child: Text(
                "Truppen",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => SquadPage()),
            );
          },
        )
      ])),
    );
  }
}
