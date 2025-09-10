import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/model/create_user_fine_command.dart';
import 'package:klubhuset/model/user_details.dart';
import 'package:klubhuset/repository/fines_repository.dart';
import 'package:klubhuset/repository/users_repository.dart';

class AssignFinesModal extends StatefulWidget {
  @override
  State<AssignFinesModal> createState() => _AssignFinesModalState();
}

class _AssignFinesModalState extends State<AssignFinesModal> {
  late Future<Map<String, dynamic>> fineTypesAndSquadData;
  List<Map<String, dynamic>> fineTypesExpanded = [];
  Map<int, Map<int, bool>> selectedUsers = {};
  Map<String, String> userFinePrices = {};

  @override
  void initState() {
    super.initState();
    fineTypesAndSquadData = _fetchFineTypesAndSquad();
  }

  Future<Map<String, dynamic>> _fetchFineTypesAndSquad() async {
    // Fetching both matchPolls and squad data
    final squad = await UsersRepository.getSquad();
    final fineTypeDetailsList = await FinesRepository.getFineTypes();

    fineTypesExpanded = (fineTypeDetailsList as List<dynamic>).map((fine) {
      selectedUsers[fine.id] = {};

      return {
        'id': fine.id,
        'name': fine.title,
        'price': fine.defaultAmount,
        'expanded': false,
      };
    }).toList();

    // Combine the two into one map
    return {
      'squad': squad,
      'fineTypeDetails': fineTypeDetailsList,
    };
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(
                  context, false); // Return false to indicate no user was added
            },
            child: Icon(
              semanticLabel: 'Annullér',
              CupertinoIcons.clear,
            )),
        middle: Text('Tildel bøder'),
        trailing: GestureDetector(
            onTap: () async {
              var wereUserFinesCreated = await addFines(context);

              if (wereUserFinesCreated && context.mounted) {
                Navigator.pop(context, wereUserFinesCreated);
              }
            },
            child: Text('Opret',
                style: TextStyle(
                    color: CupertinoColors.systemIndigo,
                    fontWeight: FontWeight.bold))),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: FutureHandler<Map<String, dynamic>>(
              future: fineTypesAndSquadData,
              noDataFoundMessage: 'Ingen bødetyper fundet.',
              onSuccess: (context, data) {
                var squad = data['squad'] as List<UserDetails>;

                if (fineTypesExpanded.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Ingen bødetyper fundet.',
                        style: TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                }
                return CupertinoListSection.insetGrouped(
                  dividerMargin: 0,
                  additionalDividerMargin: 0,
                  children: fineTypesExpanded.asMap().entries.map((entry) {
                    int index = entry.key;
                    var fine = entry.value;

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => toggleExpansion(index),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Row(
                              children: [
                                AnimatedRotation(
                                  duration: Duration(milliseconds: 300),
                                  turns: fine['expanded'] ? -0.5 : 0,
                                  curve: Curves.easeInOut,
                                  child: Icon(CupertinoIcons.chevron_down,
                                      color: CupertinoColors.systemGrey),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(fine['name'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: CupertinoTextField(
                                    placeholder: fine['price'].toString(),
                                    placeholderStyle: TextStyle(
                                        color: CupertinoColors.systemGrey),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        fine['price'] = value;
                                      });
                                    },
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: CupertinoColors.black,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    inputFormatters: [
                                      _FinePriceInputFormatter(),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text('kr.', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                        AnimatedSize(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: fine['expanded']
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 8, left: 16, right: 16, bottom: 12),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: squad.map((user) {
                                      return Builder(
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedUsers[fine['id']]![
                                                    user.id] = !(selectedUsers[
                                                        fine['id']]![user.id] ??
                                                    false);
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          user.name,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 22,
                                                        height: 22,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color:
                                                                CupertinoColors
                                                                    .black,
                                                            width: 2,
                                                          ),
                                                          color: selectedUsers[
                                                                      fine[
                                                                          'id']]![user
                                                                      .id] ==
                                                                  true
                                                              ? CupertinoColors
                                                                  .black
                                                              : CupertinoColors
                                                                  .white,
                                                        ),
                                                        child: selectedUsers[fine[
                                                                        'id']]![
                                                                    user.id] ==
                                                                true
                                                            ? Icon(
                                                                CupertinoIcons
                                                                    .checkmark,
                                                                color:
                                                                    CupertinoColors
                                                                        .white,
                                                                size: 16)
                                                            : null,
                                                      ),
                                                    ],
                                                  ),
                                                  if (user.id !=
                                                      squad
                                                          .map((x) => x.id)
                                                          .last)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          top:
                                                              12.0), // Add spacing
                                                      child: Divider(
                                                          color: CupertinoColors
                                                              .systemGrey3,
                                                          thickness: 1,
                                                          height: 1),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }),
        ),
      ),
    );
  }

  void toggleExpansion(int index) {
    setState(() {
      fineTypesExpanded[index]['expanded'] =
          !fineTypesExpanded[index]['expanded'];
    });
  }

  Future<bool> addFines(BuildContext context) async {
    List<CreateUserFineCommand> createUserFineCommand = [];

    for (var fine in fineTypesExpanded) {
      var selectedUsersIds = selectedUsers[fine['id']]!
          .entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      for (var userId in selectedUsersIds) {
        createUserFineCommand.add(CreateUserFineCommand(
            userId: userId.toString(),
            fineTypeId: fine['id'].toString(),
            owedAmount: fine['price'].toString()));
      }
    }

    if (createUserFineCommand.isEmpty) {
      // Show CupertinoDialog no users has been selected
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content:
              Text('Ingen bøder er tildelt. Vælg venligst mindst én spiller.'),
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

    await FinesRepository.addFineForUsers(createUserFineCommand);

    return true;
  }
}

// Custom formatter to limit the input to 4 digits with 2 decimal places
class _FinePriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allowing only 4 digits before and after the decimal point, accepting comma and period
    final newText = newValue.text;

    // Regexp to match up to 4 digits with 2 decimals, either using period or comma as decimal separator
    String formattedText =
        newText.replaceAll(',', '.'); // Replace comma with period

    // If empty input, allow it
    if (formattedText.isEmpty) {
      return newValue;
    }

    final regex = RegExp(r'^\d{0,4}(\.\d{0,2})?$');
    if (regex.hasMatch(formattedText)) {
      return newValue.copyWith(text: formattedText);
    }

    return oldValue; // Keep old value if the new input exceeds the constraints
  }
}
