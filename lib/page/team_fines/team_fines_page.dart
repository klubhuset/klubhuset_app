import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/model/fine_box_details.dart';
import 'package:klubhuset/model/player_fine_details.dart';
import 'package:klubhuset/page/team_fines/assign_fines_modal.dart';
import 'package:klubhuset/page/team_fines/deposit_modal.dart';
import 'package:klubhuset/repository/fines_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TeamFinesPage extends StatefulWidget {
  @override
  State<TeamFinesPage> createState() => _TeamFinesPageState();
}

class _TeamFinesPageState extends State<TeamFinesPage> {
  late Future<FineBoxDetails> fineBoxDetails;

  @override
  void initState() {
    super.initState();
    fineBoxDetails = FinesRepository.getFineBox();
  }

  Future<void> _refreshFineBox() async {
    setState(() {
      fineBoxDetails = FinesRepository.getFineBox();
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
            child: FutureHandler<FineBoxDetails>(
              future: fineBoxDetails,
              onSuccess: (context, data) {
                var playerFineDetails = data.playerFineDetails;

                return Column(
                  children: [
                    _buildBalanceSection(data),
                    _buildActionButtons(),
                    _buildMobilePaySection(),
                    _buildPlayerFineDetailsSection(playerFineDetails, width),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      transitionBetweenRoutes: false,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.of(context)
            .popUntil((route) => route.settings.name == '/'),
        child: Icon(CupertinoIcons.chevron_left, semanticLabel: 'Tilbage'),
      ),
      middle: Text('Bødekassen'),
    );
  }

  Widget _buildBalanceSection(FineBoxDetails data) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20.0),
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

  Widget _buildActionButtons() {
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
                builder: (context) => DepositModal(),
              );
              if (result == true) {
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
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/mobilepay_logo.png', width: 100),
            Text('Indsæt MobilePay Box Link'),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerFineDetailsSection(
      List<PlayerFineDetails> playerFineDetails, double width) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
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
                  child: Text('Bøder',
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
