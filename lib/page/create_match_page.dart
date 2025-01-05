import 'package:flutter/cupertino.dart';
import 'package:klubhuset/model/match_details.dart';
import 'package:klubhuset/repository/match_repository.dart';

class CreateMatchPage extends StatefulWidget {
  final List<MatchDetails> matches;

  CreateMatchPage({required this.matches});

  @override
  State<CreateMatchPage> createState() => _CreateMatchPageState();
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Opret kamp'),
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
                var wasMatchCreated = await createMatch(context);

                if (wasMatchCreated && context.mounted) {
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
                        placeholder: 'F.eks. Skjold vs Fremad',
                        validator: (String? value) =>
                            validateNameOfMatchInput(value),
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        maxLength: 255,
                      ),
                    ),
                    // TODO 1 (CVHN): Add date picker
                    // CupertinoFormRow(
                    //   prefix: Text('E-mail'),
                    //   child: CupertinoTextFormFieldRow(
                    //     placeholder: 'F.eks. lars@example.com',
                    //     validator: (String? value) => validateEmailInput(value),
                    //     keyboardType: TextInputType.emailAddress,
                    //     controller: _matchDateController,
                    //     maxLength: 255,
                    //   ),
                    // ),
                  ])),
        ));
  }

  String? validateNameOfMatchInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Indtast navnet på kampen';
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

  Future<bool> createMatch(BuildContext context) async {
    var matchName = _nameController.text;

    if (matchName.isEmpty) {
      // Show CupertinoDialog if player name or email is empty
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text('Indtast venligst navn på kampen.'),
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

    var doesMatchAlreadyExist = widget.matches.any((x) => x.name == matchName);

    if (doesMatchAlreadyExist) {
      // Show CupertinoDialog if player already exists
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text('Kampen er allerede oprettet.'),
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

    await MatchRepository.createMatch(matchName, DateTime.now());

    return true;
  }
}
