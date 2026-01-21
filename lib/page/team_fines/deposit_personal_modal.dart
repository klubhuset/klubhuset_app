import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kopa/component/button/mobile_pay_button.dart';
import 'package:kopa/component/custom_checkbox.dart';
import 'package:kopa/model/fine_details.dart';
import 'package:kopa/model/user_details.dart';
import 'package:kopa/model/user_fine_details.dart';
import 'package:kopa/repository/fines_repository.dart';

class DepositPersonalModal extends StatefulWidget {
  final int fineBoxId;
  final UserDetails userDetails;
  final UserFineDetails userFineDetails;

  DepositPersonalModal(
      {required this.fineBoxId,
      required this.userDetails,
      required this.userFineDetails});

  @override
  State<DepositPersonalModal> createState() => _DepositPersonalModalState();
}

class _DepositPersonalModalState extends State<DepositPersonalModal> {
  bool selectAllFines = false;
  int selectedAmountToDeposit = 0;
  List<FineDetails> fineDetailsListNotPaid = [];
  Set<int> selectedIndexes = {}; // Keeps track of selected fines

  @override
  void initState() {
    super.initState();

    fineDetailsListNotPaid = widget.userFineDetails.fineDetailsList
        .where((x) => !x.hasBeenPaid)
        .toList();
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      if (value == true) {
        selectedAmountToDeposit += fineDetailsListNotPaid.asMap().entries.fold(
          0,
          (sum, entry) {
            if (!selectedIndexes.contains(entry.key)) {
              return sum + entry.value.owedAmount;
            }
            return sum;
          },
        );
      } else {
        selectedAmountToDeposit = 0;
      }

      selectAllFines = value ?? false;

      selectedIndexes =
          selectAllFines ? fineDetailsListNotPaid.asMap().keys.toSet() : {};
    });
  }

  void toggleRowSelection(int index, bool? value) {
    setState(() {
      if (value == true) {
        selectedIndexes.add(index);
        selectedAmountToDeposit += fineDetailsListNotPaid[index].owedAmount;
      } else {
        selectedIndexes.remove(index);
        selectedAmountToDeposit -= fineDetailsListNotPaid[index].owedAmount;
      }

      selectAllFines = selectedIndexes.length == fineDetailsListNotPaid.length;
    });
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
        middle: Text('Indbetal'),
        trailing: GestureDetector(
            onTap: () async {
              var depositedAmount = await depositAmountToFineBox();

              if (depositedAmount != null && context.mounted) {
                Navigator.pop(context, depositedAmount);
              }
            },
            child: Text('Gem',
                style: TextStyle(
                    color: CupertinoColors.systemIndigo,
                    fontWeight: FontWeight.bold))),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                              fineDetailsListNotPaid
                                  .fold(
                                      0,
                                      (sum, fineDetail) =>
                                          sum + fineDetail.owedAmount)
                                  .toString(),
                              style: TextStyle(fontSize: 24)),
                          SizedBox(height: 5), // Space between price and label
                          Text('Mangler at blive betalt',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      )
                    ],
                  )),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(selectedAmountToDeposit.toString(),
                            style: TextStyle(fontSize: 24)),
                        SizedBox(height: 5), // Space between price and label
                        Text('Valgt beløb til indbetaling',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            'Bødetype',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            'Beløb',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        CustomCheckbox(
                          value: selectAllFines,
                          onChanged: toggleSelectAll,
                        ),
                      ],
                    ),
                    Divider(),

                    // Table Rows (Fix: Wrap in ConstrainedBox)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight:
                            400, // Sæt en passende højde, eller brug MediaQuery
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics:
                            AlwaysScrollableScrollPhysics(), // Tillader scroll
                        itemCount: fineDetailsListNotPaid.length,
                        itemBuilder: (context, index) {
                          var userFineDetails = fineDetailsListNotPaid[index];
                          bool isSelected = selectedIndexes.contains(index);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 200,
                                child: Text(
                                  userFineDetails.fineTypeDetails.title,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  '${userFineDetails.owedAmount} kr',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              CustomCheckbox(
                                value: isSelected,
                                onChanged: (value) =>
                                    toggleRowSelection(index, value),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          MobilePayButton(),
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> depositAmountToFineBox() async {
    if (selectedAmountToDeposit == 0) {
      // Show CupertinoDialog if user depositedAmount is empty or zero
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text('Vælg venligst en bøde at indbetale.'),
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

      return null;
    }

    List<int> selectedFinesToBePaid = fineDetailsListNotPaid
        .asMap()
        .entries
        .where((entry) => selectedIndexes.contains(entry.key))
        .map((entry) => entry.value)
        .map((entry) => entry.id)
        .toList();

    await FinesRepository.depositAmountToFineBox(widget.fineBoxId,
        selectedAmountToDeposit.toString(), selectedFinesToBePaid);

    return selectedAmountToDeposit.toString();
  }
}
