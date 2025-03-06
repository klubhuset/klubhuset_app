import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubhuset/component/button/button.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/helpers/url_opener.dart';
import 'package:klubhuset/model/fine_box_details.dart';
import 'package:klubhuset/model/fine_type_details.dart';
import 'package:klubhuset/model/player_details.dart';
import 'package:klubhuset/model/player_fine_details.dart';
import 'package:klubhuset/page/team_fines/assign_fines_modal.dart';
import 'package:klubhuset/page/team_fines/create_fine_type_modal.dart';
import 'package:klubhuset/page/team_fines/deposit_modal.dart';
import 'package:klubhuset/repository/fines_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum TeamOwnerFinesSegments { overview, fineTypes, personal }

class TeamFinesPage extends StatefulWidget {
  @override
  State<TeamFinesPage> createState() => _TeamFinesPageState();
}

class _TeamFinesPageState extends State<TeamFinesPage> {
  late Future<FineBoxDetails> fineBoxDetails;
  late Future<List<FineTypeDetails>> fineTypeDetails;

  TeamOwnerFinesSegments _selectedSegment = TeamOwnerFinesSegments.overview;

  @override
  void initState() {
    super.initState();

    fineBoxDetails = FinesRepository.getFineBox();
    fineTypeDetails = FinesRepository.getFineTypes();
  }

  Future<void> _refreshFineBox() async {
    setState(() {
      fineBoxDetails = FinesRepository.getFineBox();
    });
  }

  Future<void> _refreshFineTypes() async {
    setState(() {
      fineTypeDetails = FinesRepository.getFineTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: double.infinity,
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: _buildNavigationBar(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        width: double.infinity,
                        child: CupertinoSlidingSegmentedControl<
                            TeamOwnerFinesSegments>(
                          backgroundColor: CupertinoColors.systemGrey2,
                          // This represents the currently selected segmented control.
                          groupValue: _selectedSegment,
                          // Callback that sets the selected segmented control.
                          onValueChanged: (TeamOwnerFinesSegments? value) {
                            if (value != null) {
                              setState(() {
                                _selectedSegment = value;
                              });
                            }
                          },
                          children: const <TeamOwnerFinesSegments, Widget>{
                            TeamOwnerFinesSegments.overview: Text(
                              'Overblik',
                              style: TextStyle(
                                  color: CupertinoColors.black, fontSize: 13),
                            ),
                            TeamOwnerFinesSegments.fineTypes: Text(
                              'Bødetyper',
                              style: TextStyle(
                                  color: CupertinoColors.black, fontSize: 13),
                            ),
                            TeamOwnerFinesSegments.personal: Text(
                              'Personlig',
                              style: TextStyle(
                                  color: CupertinoColors.black, fontSize: 13),
                            ),
                          },
                        )),
                    SizedBox(
                      width: double.infinity,
                      child: getTeamFinesSegment(width),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget? getTeamFinesSegment(double width) {
    return FutureHandler<FineBoxDetails>(
        future: fineBoxDetails,
        onSuccess: (context, data) {
          var playerFineDetails = data.playerFineDetails;

          if (_selectedSegment == TeamOwnerFinesSegments.overview) {
            // Overview section
            return Column(
              children: [
                _buildOverallBalanceSection(data),
                _buildActionButtonsOverview(data),
                _buildMobilePaySection(),
                _buildPlayerFineDetailsSection(playerFineDetails, width),
              ],
            );
          } else if (_selectedSegment == TeamOwnerFinesSegments.fineTypes) {
            // Fine types section
            return FutureHandler(
                future: fineTypeDetails,
                onSuccess: (context, data) {
                  return Column(
                    children: [
                      _buildActionButtonFineTypes(data),
                      _buildFineTypesSection(data, width)
                    ],
                  );
                });
          } else {
            // Personal section
            PlayerFineDetails dummyObject = PlayerFineDetails(
              id: 1,
              playerDetails: PlayerDetails(
                  id: 1,
                  name: 'John Doe',
                  email: 'johndoe@example.com',
                  isTeamOwner: true,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now()),
              fineTypeDetails: FineTypeDetails(
                  id: 1,
                  title: 'Dummy Fine',
                  defaultAmount: 100,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now()),
              owedAmount: 10,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            return Column(
              children: [
                _buildPersonalBalanceSection(),
                _buildActionButtonsPersonal(data),
                _buildPersonalFineDetailsSection([dummyObject], width),
              ],
            );
          }
        });
  }

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      transitionBetweenRoutes: false,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        // TODO: This should go back to the previous page if the previous page was the match details
        onPressed: () => Navigator.of(context)
            .popUntil((route) => route.settings.name == '/'),
        child: Icon(CupertinoIcons.chevron_left, semanticLabel: 'Tilbage'),
      ),
      middle: Text('Bødekassen'),
    );
  }

  Widget _buildOverallBalanceSection(FineBoxDetails data) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCurrentBalanceText(data.currentAmount),
            SizedBox(height: 20), // Ensure space between sections
            dividerSection(),
            SizedBox(height: 20), // Ensure space after the divider
            _buildBalanceRow(data),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalBalanceSection() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPersonalBalanceText(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalBalanceText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '120',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(
          'Mangler du at betale',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildCurrentBalanceText(double currentAmount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          currentAmount.toString(),
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(
          'Balance',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildBalanceRow(FineBoxDetails data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBalanceColumn(
            data.currentAmount + data.totalOwedAmount, 'Balance efter bøder'),
        verticalDividerSection(),
        _buildBalanceColumn(data.totalOwedAmount, 'Bøder'),
      ],
    );
  }

  Widget _buildBalanceColumn(double amount, String label) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          Text(amount.toString(), style: TextStyle(fontSize: 24)),
          SizedBox(height: 5), // Space between price and label
          Text(label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionButtonsPersonal(FineBoxDetails data) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getButtonItem('Indbetal', CupertinoIcons.arrow_up_square,
                onTap: () async {
              final result = await showCupertinoModalBottomSheet(
                expand: true,
                context: context,
                builder: (context) => DepositModal(
                  fineBoxId: data.id,
                ),
              );

              if (result != null) {
                _refreshFineBox();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtonsOverview(FineBoxDetails data) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getButtonItem('Tildel', CupertinoIcons.money_dollar,
                onTap: () async {
              final result = await showCupertinoModalBottomSheet(
                expand: true,
                context: context,
                builder: (context) => AssignFinesModal(),
              );
              if (result == true) {
                _refreshFineBox();
              }
            }),
            SizedBox(width: 30),
            getButtonItem('Indbetal', CupertinoIcons.arrow_up_square,
                onTap: () async {
              final result = await showCupertinoModalBottomSheet(
                expand: true,
                context: context,
                builder: (context) => DepositModal(fineBoxId: 1),
              );

              if (result != null) {
                _refreshFineBox();
              }
            }),
            SizedBox(width: 30),
            getButtonItem('Hæv', CupertinoIcons.arrow_down_square),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilePaySection() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Betaling',
                    style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  UrlOpener.openMobilePay();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemIndigo,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  child: Text(
                    'Gå til MobilePay Box',
                    style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildPersonalFineDetailsSection(
      List<PlayerFineDetails> playerFineDetails, double width) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
      ),
      child: playerFineDetails.isEmpty
          ? Center(child: Text('Ingen bøder tildelt endnu.'))
          : Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Bødehistorik',
                      style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: DataTable(
                    horizontalMargin: 0,
                    columns: [
                      DataColumn(
                          label: SizedBox(
                              width: width * .4, child: Text('Bødetype'))),
                      DataColumn(label: SizedBox(child: Text('Beløb'))),
                    ],
                    rows: playerFineDetails.map((fineDetail) {
                      return DataRow(
                        cells: [
                          DataCell(Text(fineDetail.fineTypeDetails.title)),
                          DataCell(Text('${fineDetail.owedAmount},-')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildActionButtonFineTypes(List<FineTypeDetails> fineTypeDetails) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
                buttonText: 'Opret bødetype',
                onPressed: () async {
                  final result = await showCupertinoModalBottomSheet(
                    expand: true,
                    context: context,
                    builder: (context) => CreateFineTypeModal(
                        fineTypeDetailsList: fineTypeDetails),
                  );

                  if (result == true) {
                    _refreshFineTypes();
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildFineTypesSection(
      List<FineTypeDetails> fineTypeDetails, double width) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
      ),
      child: fineTypeDetails.isEmpty
          ? Center(child: Text('Ingen bødertyper endnu.'))
          : Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Holdets bødetyper',
                      style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: DataTable(
                    horizontalMargin: 0,
                    columns: [
                      DataColumn(
                          label:
                              SizedBox(width: width * .4, child: Text('Type'))),
                      DataColumn(label: SizedBox(child: Text('Standardbeløb'))),
                    ],
                    rows: fineTypeDetails.map((fineTypeDetail) {
                      return DataRow(
                        cells: [
                          DataCell(Text(fineTypeDetail.title)),
                          DataCell(Text('${fineTypeDetail.defaultAmount},-')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPlayerFineDetailsSection(
      List<PlayerFineDetails> playerFineDetails, double width) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
      ),
      child: playerFineDetails.isEmpty
          ? Center(child: Text('Ingen bøder tildelt endnu.'))
          : Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Holdets bøder',
                      style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: DataTable(
                    horizontalMargin: 0,
                    columns: [
                      DataColumn(
                          label: SizedBox(
                              width: width * .4, child: Text('Spiller'))),
                      DataColumn(label: SizedBox(child: Text('Beløb'))),
                    ],
                    rows: playerFineDetails.map((fineDetail) {
                      return DataRow(
                        cells: [
                          DataCell(Text(fineDetail.playerDetails.name)),
                          DataCell(Text('${fineDetail.owedAmount},-')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
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
            Icon(buttonIcon, color: CupertinoColors.black, size: 24),
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
      ),
    );
  }

  Widget verticalDividerSection() {
    return SizedBox(
      height: 50,
      child: VerticalDivider(
        color: CupertinoColors.systemGrey3,
        thickness: 1,
        width: 1,
      ),
    );
  }

  Widget dividerSection() {
    return SizedBox(
      width: double.infinity,
      child: Divider(
        color: CupertinoColors.systemGrey3,
        thickness: 1,
        height: 1,
      ),
    );
  }
}
