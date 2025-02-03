class CreatePlayerFineCommand {
  String playerId;
  String fineTypeId;
  String owedAmount;

  CreatePlayerFineCommand({
    required this.playerId,
    required this.fineTypeId,
    required this.owedAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'fineTypeId': fineTypeId,
      'owedAmount': owedAmount,
    };
  }
}
