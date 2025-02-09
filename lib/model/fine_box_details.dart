import 'package:klubhuset/model/player_fine_details.dart';

class FineBoxDetails {
  final int id;
  final double currentAmount;
  final double totalOwedAmount;
  final List<PlayerFineDetails> playerFineDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  FineBoxDetails(
      {required this.id,
      required this.currentAmount,
      required this.totalOwedAmount,
      required this.playerFineDetails,
      required this.createdAt,
      required this.updatedAt});

  factory FineBoxDetails.fromJson(Map<String, dynamic> json) {
    return FineBoxDetails(
      id: json['id'],
      currentAmount: json['currentAmount'] + .0, // Convert to double
      totalOwedAmount: json['totalOwedAmount'] + .0, // Convert to double
      playerFineDetails: List<PlayerFineDetails>.from(
          json['playerFineDetails'].map((x) => PlayerFineDetails.fromJson(x))),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
