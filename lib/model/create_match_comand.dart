class CreateMatchCommand {
  String name;
  DateTime matchDate;

  CreateMatchCommand(this.name, this.matchDate);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'matchDate': matchDate.toString(),
    };
  }
}
