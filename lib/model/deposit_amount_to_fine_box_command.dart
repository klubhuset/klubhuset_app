import 'dart:convert';

class DepositAmountToFineBoxCommand {
  final String fineBoxId;
  final String amountToDeposit;
  final List<String> userFineIds;

  DepositAmountToFineBoxCommand({
    required this.fineBoxId,
    required this.amountToDeposit,
    required this.userFineIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'fineBoxId': fineBoxId,
      'amountToDeposit': amountToDeposit,
      'userFineIds': jsonEncode(userFineIds),
    };
  }
}
