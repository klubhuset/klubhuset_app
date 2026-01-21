import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:kopa/model/match_details.dart';
import 'package:kopa/repository/match_repository.dart';

class CreateMatchPage extends StatefulWidget {
  final List<MatchDetails> matches;

  CreateMatchPage({required this.matches});

  @override
  State<CreateMatchPage> createState() => _CreateMatchPageState();
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  final _teamAController = TextEditingController();
  final _teamBController = TextEditingController();
  final _locationController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _selectedDate;
  DateTime? _selectedMeetingTime;

  @override
  void dispose() {
    _teamAController.dispose();
    _teamBController.dispose();
    _locationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    DateTime tempPickedDate = _selectedDate ?? DateTime.now();

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: CupertinoNavigationBar(
                  middle: Text('Vælg dato og tid'),
                  leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text('Annullér'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text('OK'),
                    onPressed: () {
                      setState(() {
                        _selectedDate = tempPickedDate;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              // Date/time picker
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: tempPickedDate,
                  mode: CupertinoDatePickerMode.dateAndTime,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newDate) {
                    tempPickedDate = newDate;
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMeetingTime() async {
    DateTime tempPickedDate = _selectedMeetingTime ?? DateTime.now();

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: CupertinoNavigationBar(
                  middle: Text('Vælg mødetid'),
                  leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text('Annullér'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text('OK'),
                    onPressed: () {
                      setState(() {
                        _selectedMeetingTime = tempPickedDate;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
              // Date/time picker
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: tempPickedDate,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newDate) {
                    tempPickedDate = newDate;
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        navigationBar: CupertinoNavigationBar(
          middle: Text('Opret kamp'),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context, false),
            child: Icon(CupertinoIcons.clear, semanticLabel: 'Annullér'),
          ),
          trailing: GestureDetector(
            onTap: () async {
              final created = await _createMatch();
              if (created && context.mounted) {
                Navigator.pop(context, true);
              }
            },
            child: Text('Opret',
                style: TextStyle(
                    color: CupertinoColors.activeBlue,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 15),
          child: SafeArea(
            child: CupertinoFormSection.insetGrouped(
              children: [
                CupertinoFormRow(
                  prefix: Text('Hjemmehold',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  child: CupertinoTextFormFieldRow(
                    controller: _teamAController,
                    placeholder: 'Fx Sønderjyske',
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('Udehold',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  child: CupertinoTextFormFieldRow(
                    controller: _teamBController,
                    placeholder: 'Fx AGF',
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('Tidspunkt',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  child: GestureDetector(
                    onTap: _pickDateTime,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('dd.MM.yyyy - HH:mm')
                                .format(_selectedDate!)
                            : 'Vælg dato og tid',
                        style: TextStyle(
                          color: _selectedDate != null
                              ? CupertinoColors.label
                              : CupertinoColors.placeholderText,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('Mødetid',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  child: GestureDetector(
                    onTap: _pickMeetingTime,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      child: Text(
                        _selectedMeetingTime != null
                            ? DateFormat('dd.MM.yyyy - HH:mm')
                                .format(_selectedMeetingTime!)
                            : 'VALGFRIT: Vælg mødetid',
                        style: TextStyle(
                          color: _selectedMeetingTime != null
                              ? CupertinoColors.label
                              : CupertinoColors.placeholderText,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('Lokation',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  child: CupertinoTextFormFieldRow(
                    controller: _locationController,
                    placeholder: 'Fx Sydbank Park',
                  ),
                ),
                CupertinoFormRow(
                  prefix: Text('Noter',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  child: CupertinoTextFormFieldRow(
                    controller: _noteController,
                    placeholder: 'Evt. kommentarer',
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> _createMatch() async {
    final teamA = _teamAController.text.trim();
    final teamB = _teamBController.text.trim();
    final location = _locationController.text.trim();
    final notes = _noteController.text.trim();
    final date = _selectedDate;
    final meetingTime = _selectedMeetingTime;

    if (teamA.isEmpty || teamB.isEmpty || date == null) {
      await _showError('Udfyld begge hold og vælg dato.');
      return false;
    }

    if (teamA.toLowerCase() == teamB.toLowerCase()) {
      await _showError('Første og andet hold må ikke være ens.');
      return false;
    }

    // Create match
    await MatchRepository.createMatch(
      teamA,
      teamB,
      date,
      location,
      meetingTime,
      notes: notes,
    );

    return true;
  }

  Future<void> _showError(String message) async {
    await showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text('Fejl'),
        content: Text(message),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }
}
