class CreateMatchCommand {
  String name;
  String address;
  DateTime matchDate;

  CreateMatchCommand(this.name, this.address, this.matchDate);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'matchDate': matchDate.toString(),
    };
  }
}
