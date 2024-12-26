class CreatePlayerCommand {
  String name;
  String email;
  bool isTeamOwner;

  CreatePlayerCommand(this.name, this.email, this.isTeamOwner);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'isTeamOwner': isTeamOwner.toString(),
    };
  }
}
