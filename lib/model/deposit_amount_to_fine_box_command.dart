class DepositAmountToFineBoxCommand {
  final String fineBoxId;
  final String amountToDeposit;

  DepositAmountToFineBoxCommand(
      {required this.fineBoxId, required this.amountToDeposit});

  Map<String, dynamic> toJson() {
    return {
      'fineBoxId': fineBoxId,
      'amountToDeposit': amountToDeposit,
    };
  }
}
