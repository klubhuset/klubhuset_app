import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/model/player_fine_details.dart';
import 'package:klubhuset/repository/players_repository.dart';

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
                        getButtonItem('Tildel', CupertinoIcons.money_dollar),
                        SizedBox(width: 30),
                        getButtonItem(
                            'Indbetal', CupertinoIcons.arrow_up_square),
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
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Indsæt MobilePay Box Link')],
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SafeArea(
                      child: FutureHandler<List<PlayerFineDetails>>(
                          future: playerFineDetailsList,
                          noDataFoundMessage: 'Ingen bøder fundet.',
                          onSuccess: (context, data) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CupertinoListSection.insetGrouped(
                                    dividerMargin: 0,
                                    additionalDividerMargin: 0,
                                    children: List.generate(
                                      data.length,
                                      (index) {
                                        final playerFineDetails = data[index];

                                        return CupertinoListTile(
                                          padding: EdgeInsets.only(
                                              top: 15.0,
                                              bottom: 15.0,
                                              left: 20,
                                              right: 20),
                                          title: Text(playerFineDetails
                                              .playerDetails.name),
                                          trailing: Text(playerFineDetails
                                              .owedAmount
                                              .toString()),
                                          onTap: () {
                                            // Add your code here
                                          },
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          })),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget getButtonItem(String buttonText, IconData buttonIcon) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 100,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
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
      ),
    );
  }
}
