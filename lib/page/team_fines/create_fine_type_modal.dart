import 'package:flutter/cupertino.dart';
import 'package:klubhuset/model/fine_type_details.dart';
import 'package:klubhuset/repository/fines_repository.dart';

class CreateFineTypeModal extends StatefulWidget {
  final List<FineTypeDetails> fineTypeDetailsList;

  CreateFineTypeModal({required this.fineTypeDetailsList});

  @override
  State<CreateFineTypeModal> createState() => _CreateFineTypeModalState();
}

class _CreateFineTypeModalState extends State<CreateFineTypeModal> {
  late TextEditingController _titleController;
  late TextEditingController _defaultAmountController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _defaultAmountController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _defaultAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Opret bødetype'),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context,
                    false); // Return false to indicate no user was added
              },
              child: Icon(
                semanticLabel: 'Annullér',
                CupertinoIcons.clear,
              )),
          trailing: GestureDetector(
              onTap: () async {
                var wasFineTypeCreated = await createFineType(context);

                if (wasFineTypeCreated && context.mounted) {
                  Navigator.pop(context, wasFineTypeCreated);
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
                      prefix: Text('Titel'),
                      child: CupertinoTextFormFieldRow(
                        placeholder: 'F.eks. "Kommet for sent"',
                        validator: (String? value) =>
                            validateTitleOfFineTypeInput(value),
                        keyboardType: TextInputType.name,
                        controller: _titleController,
                        maxLength: 255,
                      ),
                    ),
                    CupertinoFormRow(
                      prefix: Text('Beløb'),
                      child: CupertinoTextFormFieldRow(
                        placeholder: 'F.eks. 100',
                        validator: (String? value) =>
                            validateDefaultAmountInput(value),
                        keyboardType: TextInputType.number,
                        controller: _defaultAmountController,
                      ),
                    ),
                  ])),
        ));
  }

  String? validateTitleOfFineTypeInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Indtast titel på bødetype';
    }

    return null;
  }

  String? validateDefaultAmountInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Indtast standardbeløb for bødetypen';
    }

    return null;
  }

  Future<bool> createFineType(BuildContext context) async {
    var fineTypeTitle = _titleController.text;
    var fineTypeDefaultAmount = _defaultAmountController.text;
    var doesFineTypeAlreadyExistByTitle =
        widget.fineTypeDetailsList.any((x) => x.title == fineTypeTitle);

    if (fineTypeTitle.isEmpty || fineTypeDefaultAmount.isEmpty) {
      // Show CupertinoDialog if user title or default amount is empty
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text('Indtast venligst titel og standardbeløb.'),
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

    if (doesFineTypeAlreadyExistByTitle) {
      // Show CupertinoDialog if fine type already exists
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text(
              'Bødetype eksisterer allerede. Indtast venligst en anden titel.'),
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

    await FinesRepository.createFineType(
      fineTypeTitle,
      fineTypeDefaultAmount,
    );

    return true;
  }
}
