import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/model/player_fine_details.dart';
import 'package:klubhuset/page/team_fines/assign_fines_modal.dart';
import 'package:klubhuset/repository/players_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TeamFinesPage extends StatefulWidget {
  @override
  State<TeamFinesPage> createState() => _TeamFinesPageState();
}

class _TeamFinesPageState extends State<TeamFinesPage> {
  late Future<List<PlayerFineDetails>> playerFineDetailsList;

  @override
  void initState() {
    super.initState();
    playerFineDetailsList = PlayersRepository.getAllPlayerFines();
  }

  // ignore: unused_element
  Future<void> _refreshSquad() async {
    setState(() {
      playerFineDetailsList = PlayersRepository.getAllPlayerFines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: double.infinity,
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context)
                    .popUntil((route) => route.settings.name == '/');
              },
              child: Icon(
                semanticLabel: 'Tilbage',
                CupertinoIcons.chevron_left,
              )),
          middle: Text('Bødekassen'),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('12345')],
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // children: [Text('Gå til MobilePay Box')],
                      children: [
                        getButtonItem('Tildel', CupertinoIcons.money_dollar,
                            onTap: () async {
                          await showCupertinoModalBottomSheet(
                            expand: true,
                            context: context,
                            builder: (context) => AssignFinesModal(),
                          );
                        }),
                        SizedBox(width: 30),
                        getButtonItem(
                          'Indbetal',
                          CupertinoIcons.arrow_up_square,
                        ),
                        SizedBox(width: 30),
                        getButtonItem('Hæv', CupertinoIcons.arrow_down_square),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/mobilepay_logo.png'),
                              width: 100,
                            ),
                            Text('Indsæt MobilePay Box Link'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground,
                ),
                child: SafeArea(
                    child: FutureHandler<List<PlayerFineDetails>>(
                        future: playerFineDetailsList,
                        noDataFoundMessage: 'Ingen bøder fundet.',
                        onSuccess: (context, data) {
                          return Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Bøder',
                                  style: TextStyle(
                                      color: CupertinoColors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: 1,
                                child: DataTable(
                                  horizontalMargin: 0,
                                  columns: [
                                    DataColumn(
                                      label: SizedBox(
                                        width: width * .4,
                                        child: Text('Spiller'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        child: Text('Beløb'),
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(data.length, (index) {
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(
                                            data[index].playerDetails.name)),
                                        DataCell(Text(
                                            '${data[index].owedAmount},-')),
                                      ],
                                    );
                                  }),
                                ),
                              )
                            ],
                          );
                        })),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget getButtonItem(String buttonText, IconData buttonIcon,
      {Function()? onTap}) {
    return Container(
        padding: EdgeInsets.all(10),
        width: 100,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onTap,
            child: Column(
              children: [
                Icon(
                  buttonIcon,
                  color: CupertinoColors.black,
                  size: 24,
                ),
                SizedBox(height: 8),
                Text(
                  buttonText,
                  style: TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }

  // void _showPopupSurface(BuildContext context) {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CupertinoPopupSurface(
  //         child: Container(
  //           height: 1000,
  //           margin: EdgeInsets.only(bottom: 50),
  //           padding: const EdgeInsets.all(15.0),
  //           child: Column(
  //             children: <Widget>[
  //               Expanded(
  //                 child: Container(
  //                   alignment: Alignment.center,
  //                   decoration: BoxDecoration(
  //                     color: CupertinoTheme.of(context).scaffoldBackgroundColor,
  //                     borderRadius: BorderRadius.circular(8.0),
  //                   ),
  //                   child: const Text('This is a popup surface.'),
  //                 ),
  //               ),
  //               const SizedBox(height: 8.0),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: CupertinoButton(
  //                   color: CupertinoTheme.of(context).scaffoldBackgroundColor,
  //                   onPressed: () => Navigator.pop(context),
  //                   child: const Text(
  //                     'Close',
  //                     style: TextStyle(color: CupertinoColors.systemBlue),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
