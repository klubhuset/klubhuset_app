import 'package:flutter/foundation.dart';

class Player {
  final int id = UniqueKey().hashCode;
  final String name;
  final bool isTeamOwner;

  Player(this.name, this.isTeamOwner);

  @override
  String toString() => '$name (id=$id)';
}
