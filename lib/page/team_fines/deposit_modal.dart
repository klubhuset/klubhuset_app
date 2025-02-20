import 'package:flutter/cupertino.dart';

class DepositModal extends StatefulWidget {
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
              // var werePlayerFinesCreated = await addFines(context);

              // if (werePlayerFinesCreated && context.mounted) {
              //   Navigator.pop(context, werePlayerFinesCreated);
              // }
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
                            'Gå til MobilePay',
                            style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline),
                          ),
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
}
