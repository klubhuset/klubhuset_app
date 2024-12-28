import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      // Container for team name
      Container(
          margin: EdgeInsets.fromLTRB(175, 30, 0, 30), child: Text('På vej!'))
    ])));
  }
}
