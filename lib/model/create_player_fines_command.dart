import 'dart:convert';

import 'package:klubhuset/model/create_player_fine_command.dart';

class CreatePlayerFinesCommand {
  final List<CreatePlayerFineCommand> createPlayerFineCommands;

  CreatePlayerFinesCommand(this.createPlayerFineCommands);

  Map<String, dynamic> toJson() {
    return {
      'createPlayerFineCommands':
          jsonEncode(createPlayerFineCommands.map((e) => e.toJson()).toList())
    };
  }
}
