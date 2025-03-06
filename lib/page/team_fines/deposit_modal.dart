import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/button/mobile_pay_button.dart';
import 'package:klubhuset/repository/fines_repository.dart';

class DepositModal extends StatefulWidget {
  final int fineBoxId;

  DepositModal({required this.fineBoxId});

  @override
  State<DepositModal> createState() => _DepositModalState();
}

class _DepositModalState extends State<DepositModal> {
  late TextEditingController _depositController;

  @override
  void initState() {
    super.initState();

    _depositController = TextEditingController();
  }

  @override
  void dispose() {
    _depositController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context,
                  false); // Return false to indicate no player was added
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
                          Text('123', style: TextStyle(fontSize: 24)),
                          SizedBox(height: 5), // Space between price and label
                          Text('Mangler at blive betalt',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      )
                    ],
                  )),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Text('Beløb til indbetaling',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 5), // Space between price and label
                    CupertinoTextFormFieldRow(
                      placeholder: 'F.eks. 100',
                      controller: _depositController,
                      keyboardType: TextInputType.number,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CupertinoColors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
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
    var depositedAmount = _depositController.text;

    if (depositedAmount.isEmpty || depositedAmount == '0') {
      // Show CupertinoDialog if player depositedAmount is empty or zero
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Fejl'),
          content: Text('Indtast venligst et beløb større end 0 kr.'),
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

    await FinesRepository.depositAmountToFineBox(
        widget.fineBoxId, depositedAmount);

    return depositedAmount;
  }
}
