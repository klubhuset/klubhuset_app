class Player {
  final int id;
  final String name;
  final bool isTeamOwner;

  const Player(this.id, this.name, this.isTeamOwner);

  @override
  String toString() => '$name (id=$id)';
}
