import 'package:flutter/cupertino.dart';

class AssignFinesModal extends StatefulWidget {
  @override
  State<AssignFinesModal> createState() => _AssignFinesModalState();
}

class _AssignFinesModalState extends State<AssignFinesModal> {
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;

  // @override
  // Widget build(BuildContext context) {
  // return CupertinoPageScaffold(
  //     backgroundColor: CupertinoColors.systemGrey6,
  //     navigationBar: CupertinoNavigationBar(
  //       middle: Text('Tildel bøder'),
  //       leading: GestureDetector(
  //           onTap: () {
  //             Navigator.pop(context,
  //                 false); // Return false to indicate no player was added
  //           },
  //           child: Icon(
  //             semanticLabel: 'Annullér',
  //             CupertinoIcons.clear,
  //           )),
  //       trailing: GestureDetector(
  //           onTap: () async {
  //             if (context.mounted) {
  //               Navigator.pop(context, true);
  //             }
  //           },
  //           child: Text('Opret',
  //               style: TextStyle(
  //                   color: CupertinoColors.systemIndigo,
  //                   fontWeight: FontWeight.bold))),
  //     ),
  //     child: SafeArea(
  //         child: SingleChildScrollView(
  //             child: CupertinoListSection.insetGrouped(
  //       children: <Widget>[
  //         CupertinoListTile(
  //           title: Text('Item 1'),
  //           onTap: () {
  //             setState(() {
  //               // Toggle the expansion state of Item 1
  //               isExpanded1 = !isExpanded1;
  //             });
  //           },
  //         ),
  //         if (isExpanded1)
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 16),
  //             child: Column(
  //               children: [
  //                 Text('Additional information for Item 1'),
  //                 // Add more widgets here for additional information
  //               ],
  //             ),
  //           ),
  //         CupertinoListTile(
  //           title: Text('Item 2'),
  //           onTap: () {
  //             setState(() {
  //               // Toggle the expansion state of Item 2
  //               isExpanded2 = !isExpanded2;
  //             });
  //           },
  //         ),
  //         if (isExpanded2)
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 16),
  //             child: Column(
  //               children: [
  //                 Text('Additional information for Item 2'),
  //                 // Add more widgets here for additional information
  //               ],
  //             ),
  //           ),
  //       ],
  //     ))));
  List<Map<String, dynamic>> fineTypes = [
    {"name": "Pis i badet", "price": 215, "expanded": false},
    {"name": "Gult kort", "price": 215, "expanded": false},
    {"name": "Glemt støvler", "price": 215, "expanded": false},
    {"name": "Rødt kort", "price": 215, "expanded": false},
    {"name": "Kæmpe chance", "price": 215, "expanded": false},
  ];

  Map<String, int> playerFines = {};
  List<String> players = ["Anders Holze Brandt", "Spiller 2", "Spiller 3"];

  void toggleExpansion(int index) {
    setState(() {
      fineTypes[index]["expanded"] = !fineTypes[index]["expanded"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Tildel bøder"),
      ),
      child: SafeArea(
        child: CupertinoListSection.insetGrouped(
          children: fineTypes.asMap().entries.map((entry) {
            int index = entry.key;
            var fine = entry.value;
            return Column(
              children: [
                GestureDetector(
                  onTap: () => toggleExpansion(index),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          child: AnimatedRotation(
                            duration: Duration(milliseconds: 250),
                            turns: fine["expanded"] ? 0.5 : 0,
                            curve: Curves.easeInOut,
                            child: Icon(CupertinoIcons.chevron_down,
                                color: CupertinoColors.black),
                          ),
                        ),
                        Expanded(
                          child: Text(fine["name"],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("${fine["price"]},-",
                              style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: fine["expanded"]
                      ? Column(
                          children: players.map((player) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(player, style: TextStyle(fontSize: 16)),
                                  SizedBox(
                                    width: 80,
                                    child: CupertinoTextField(
                                      keyboardType: TextInputType.number,
                                      placeholder: "${fine["price"]}",
                                      onChanged: (value) {
                                        setState(() {
                                          playerFines[player] =
                                              int.tryParse(value) ??
                                                  fine["price"];
                                        });
                                      },
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 16),
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.white,
                                        border: Border.all(
                                            color: CupertinoColors.systemGrey,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      : SizedBox.square(),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
