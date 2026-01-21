import 'package:flutter/cupertino.dart';
import 'package:kopa/model/user_details.dart';
import 'package:kopa/repository/users_repository.dart';

class AddUserToTeamPage extends StatefulWidget {
  final List<UserDetails> squad;

  AddUserToTeamPage({required this.squad});

  @override
  State<AddUserToTeamPage> createState() => _AddUserToTeamPageState();
}

class _AddUserToTeamPageState extends State<AddUserToTeamPage> {
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
              child: Icon(
                semanticLabel: 'Annullér',
                CupertinoIcons.clear,
              )),
          trailing: GestureDetector(
              onTap: () async {
                var wasPlayerAddedToSquad = await addPlayerToSquad(context);

                if (wasPlayerAddedToSquad && context.mounted) {
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
                  header: const Text(''),
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

  Future<bool> addPlayerToSquad(BuildContext context) async {
    var playerName = _nameController.text;
    var playerEmail = _emailController.text;
    var doesPlayerAlreadyExistByNameOrEmail =
        widget.squad.any((x) => x.name == playerName || x.email == playerEmail);

    if (playerName.isEmpty || playerEmail.isEmpty) {
      // Show CupertinoDialog if player name or email is empty
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text('Indtast venligst navn og e-mail.'),
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

      return false;
    }

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

      return false;
    }

    await UsersRepository.createPlayer(
      playerName,
      playerEmail,
    );

    return true;
  }
}
