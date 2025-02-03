import 'package:flutter/cupertino.dart';
import 'package:klubhuset/component/future_handler.dart';
import 'package:klubhuset/model/create_player_fine_command.dart';
import 'package:klubhuset/model/player_details.dart';
import 'package:klubhuset/model/player_fine_details.dart';
import 'package:klubhuset/repository/fines_repository.dart';
import 'package:klubhuset/repository/players_repository.dart';

class AssignFinesModal extends StatefulWidget {
  @override
  State<AssignFinesModal> createState() => _AssignFinesModalState();
}

class _AssignFinesModalState extends State<AssignFinesModal> {
  late Future<Map<String, dynamic>> fineTypesAndSquadData;
  List<Map<String, dynamic>> fineTypesExpanded = [];
  Map<int, Map<int, bool>> selectedPlayers = {};
  Map<String, String> playerFinePrices = {};

  @override
  void initState() {
    super.initState();
    fineTypesAndSquadData = _fetchFineTypesAndSquad();
  }

  Future<Map<String, dynamic>> _fetchFineTypesAndSquad() async {
    // Fetching both matchPolls and squad data
    final squad = await PlayersRepository.getSquad();
    final fineTypeDetailsList = await FinesRepository.getFineTypes();

    fineTypesExpanded = (fineTypeDetailsList as List<dynamic>).map((fine) {
      selectedPlayers[fine.id] = {};

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
              Navigator.pop(context,
                  false); // Return false to indicate no player was added
            },
            child: Icon(
              semanticLabel: 'Annullér',
              CupertinoIcons.clear,
            )),
        middle: Text('Tildel bøder'),
        trailing: GestureDetector(
            onTap: () async {
              var werePlayerFinesCreated = await addFines(context);

              if (werePlayerFinesCreated && context.mounted) {
                Navigator.pop(context, werePlayerFinesCreated);
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
                var squad = data['squad'] as List<PlayerDetails>;

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
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        fine['price'] = int.tryParse(value) ??
                                            fine['price'];
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
                                    children: squad.map((player) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(player.name,
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedPlayers[fine['id']]![
                                                          player.id] =
                                                      !(selectedPlayers[
                                                                  fine['id']]![
                                                              player.id] ??
                                                          false);
                                                });
                                              },
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color:
                                                        CupertinoColors.black,
                                                    width: 2,
                                                  ),
                                                  color: selectedPlayers[
                                                                  fine['id']]![
                                                              player.id] ==
                                                          true
                                                      ? CupertinoColors.black
                                                      : CupertinoColors.white,
                                                ),
                                                child: selectedPlayers[
                                                                fine['id']]![
                                                            player.id] ==
                                                        true
                                                    ? Icon(
                                                        CupertinoIcons
                                                            .checkmark,
                                                        color: CupertinoColors
                                                            .white,
                                                        size: 18)
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
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
    List<CreatePlayerFineCommand> createPlayerFineCommands = [];

    for (var fine in fineTypesExpanded) {
      var selectedPlayersIds = selectedPlayers[fine['id']]!
          .entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      for (var playerId in selectedPlayersIds) {
        createPlayerFineCommands.add(CreatePlayerFineCommand(
            playerId: playerId.toString(),
            fineTypeId: fine['id'].toString(),
            owedAmount: fine['price'].toString()));
      }
    }

    if (createPlayerFineCommands.isEmpty) {
      // Show CupertinoDialog no players has been selected
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

    await FinesRepository.addFineForPlayers(createPlayerFineCommands);

    return true;
  }
}
