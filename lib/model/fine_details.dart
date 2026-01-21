import 'package:kopa/model/fine_type_details.dart';

class FineDetails {
  final int id;
  final FineTypeDetails fineTypeDetails;
  final int owedAmount;
  final bool hasBeenPaid;
  final DateTime createdAt;
  final DateTime updatedAt;

  FineDetails({
    required this.id,
    required this.fineTypeDetails,
    required this.owedAmount,
    required this.hasBeenPaid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FineDetails.fromJson(Map<String, dynamic> json) {
    return FineDetails(
      id: json['id'],
      fineTypeDetails: FineTypeDetails.fromJson(json['fineTypeDetails']),
      owedAmount: json['owedAmount'],
      hasBeenPaid: json['hasBeenPaid'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
