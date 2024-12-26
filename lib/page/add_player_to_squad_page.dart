import 'package:flutter/cupertino.dart';
import 'package:klubhuset/model/player_details.dart';
import 'package:klubhuset/repository/players_repository.dart';

class AddPlayerToSquadPage extends StatefulWidget {
  final List<PlayerDetails> squad;

  AddPlayerToSquadPage({required this.squad});

  @override
  State<AddPlayerToSquadPage> createState() => _AddPlayerToSquadPageState();
}

class _AddPlayerToSquadPageState extends State<AddPlayerToSquadPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Tilføj spiller'),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context,
                  false); // Return false to indicate no player was added
            },
            child: Text('Annullér',
                style: TextStyle(
                    color: CupertinoColors.systemIndigo,
                    fontWeight: FontWeight.bold)),
          ),
          trailing: GestureDetector(
              onTap: () async {
                await addPlayerToSquad(context);

                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              },
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
                  header: const Text('Spilleroplysninger'),
                  children: <Widget>[
                    CupertinoFormRow(
                      prefix: Text('Navn'),
                      child: CupertinoTextFormFieldRow(
                        placeholder: 'F.eks. Lars Larsen',
                        validator: (String? value) =>
                            validateNameOfPlayerInput(value),
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        maxLength: 255,
                      ),
                    ),
                    CupertinoFormRow(
                      prefix: Text('E-mail'),
                      child: CupertinoTextFormFieldRow(
                        placeholder: 'F.eks. lars@example.com',
                        validator: (String? value) => validateEmailInput(value),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        maxLength: 255,
                      ),
                    ),
                  ])),
        ));
  }

  String? validateNameOfPlayerInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Indtast navn på spiller';
    }

    return null;
  }

  String? validateEmailInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Indtast e-mail';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Indtast en gyldig e-mail';
    }

    return null;
  }

  Future<void> addPlayerToSquad(BuildContext context) async {
    var playerName = _nameController.text;
    var playerEmail = _emailController.text;
    var doesPlayerAlreadyExistByNameOrEmail =
        widget.squad.any((x) => x.name == playerName || x.email == playerEmail);
    ;

    if (doesPlayerAlreadyExistByNameOrEmail) {
      // Show CupertinoDialog if player already exists
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text(
              'Spilleren eksisterer allerede i truppen. Angiv et andet navn og/eller e-mail.'),
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

    await PlayersRepository.createPlayer(
      playerName,
      playerEmail,
    );
  }
}
