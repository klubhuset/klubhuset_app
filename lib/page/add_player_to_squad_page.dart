import 'package:flutter/cupertino.dart';
import 'package:klubhuset/page/squad_page.dart';
import 'package:klubhuset/repository/players_repository.dart';

class AddPlayerToSquadPage extends StatefulWidget {
  @override
  State<AddPlayerToSquadPage> createState() => _AddPlayerToSquadPageState();
}

class _AddPlayerToSquadPageState extends State<AddPlayerToSquadPage> {
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
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Ny afstemning'),
          trailing: GestureDetector(
              onTap: () => addPlayerToSquad(context),
              child: Text('Opret',
                  style: TextStyle(
                      color: CupertinoColors.systemIndigo,
                      fontWeight: FontWeight.bold))),
        ),
        child: SafeArea(
          child: Form(
              autovalidateMode: AutovalidateMode.always,
              onChanged: () {
                Form.maybeOf(primaryFocus!.context!)?.save();
              },
              child: CupertinoFormSection.insetGrouped(
                  header: const Text('Navn på spiller'),
                  children: <Widget>[
                    CupertinoTextFormFieldRow(
                      placeholder: 'F.eks. Lars Larsen',
                      validator: (String? value) =>
                          validateNameOfPlayerInput(value),
                      keyboardType: TextInputType.name,
                      controller: _textController,
                    )
                  ])),
        ));
  }

  String? validateNameOfPlayerInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Indtast navn på spiller';
    }

    return null;
  }

  void addPlayerToSquad(BuildContext context) {
    var playerName = _textController.text;
    var doesPlayerAlreadyExistByName =
        PlayersRepository.doesPlayerAlreadyExistByName(playerName);

    if (doesPlayerAlreadyExistByName) {
      // Show CupertinoDialog if player already exists
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text(
              'Spilleren eksisterer allerede i truppen. Angiv et andet navn.'),
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

    PlayersRepository.addPlayer(_textController.text, false);

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => SquadPage()),
    );
  }
}
