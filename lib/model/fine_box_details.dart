import 'package:klubhuset/model/user_fine_details.dart';

class FineBoxDetails {
  final int id;
  final double currentAmount;
  final double totalOwedAmount;
  final List<UserFineDetails> userFineDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  FineBoxDetails(
      {required this.id,
      required this.currentAmount,
      required this.totalOwedAmount,
      required this.userFineDetails,
      required this.createdAt,
      required this.updatedAt});

  factory FineBoxDetails.fromJson(Map<String, dynamic> json) {
    return FineBoxDetails(
      id: json['id'],
      currentAmount: json['currentAmount'] + .0, // Convert to double
      totalOwedAmount: json['totalOwedAmount'] + .0, // Convert to double
      userFineDetails: json['userFineDetails'] != null
          ? List<UserFineDetails>.from(
              json['userFineDetails'].map((x) => UserFineDetails.fromJson(x)))
          : [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
