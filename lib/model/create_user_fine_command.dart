class CreateUserFineCommand {
  String userId;
  String fineTypeId;
  String owedAmount;

  CreateUserFineCommand({
    required this.userId,
    required this.fineTypeId,
    required this.owedAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fineTypeId': fineTypeId,
      'owedAmount': owedAmount,
    };
  }
}
