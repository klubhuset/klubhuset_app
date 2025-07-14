class CreateMatchCommand {
  final String firstTeam;
  final String secondTeam;
  final String location;
  final DateTime date;
  final String? notes;

  CreateMatchCommand(
    this.firstTeam,
    this.secondTeam,
    this.location,
    this.date,
    this.notes,
  );

  Map<String, dynamic> toJson() {
    return {
      'firstTeam': firstTeam,
      'secondTeam': secondTeam,
      'location': location,
      'date': date.toString(),
    };
  }
}
