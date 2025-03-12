class DepositAmountToFineBoxCommand {
  final String fineBoxId;
  final String amountToDeposit;
  final List<String> playerFineIds;

  DepositAmountToFineBoxCommand(
      {required this.fineBoxId,
      required this.amountToDeposit,
      required this.playerFineIds});

  Map<String, dynamic> toJson() {
    return {
      'fineBoxId': fineBoxId,
      'amountToDeposit': amountToDeposit,
      'playerFineIds': playerFineIds,
    };
  }
}
