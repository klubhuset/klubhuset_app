import 'dart:convert';

import 'package:klubhuset/model/create_user_fine_command.dart';

class CreateUserFinesCommand {
  final List<CreateUserFineCommand> createUserFinesCommand;

  CreateUserFinesCommand(this.createUserFinesCommand);

  Map<String, dynamic> toJson() {
    return {
      'CreateUserFinesCommand':
          jsonEncode(createUserFinesCommand.map((e) => e.toJson()).toList())
    };
  }
}
