import 'package:klubhuset/model/fine_type_details.dart';
import 'package:klubhuset/model/player_details.dart';

class PlayerFineDetails {
  final int id;
  final PlayerDetails playerDetails;
  final FineTypeDetails fineTypeDetails;
  final int owedAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlayerFineDetails({
    required this.id,
    required this.playerDetails,
    required this.fineTypeDetails,
    required this.owedAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlayerFineDetails.fromJson(Map<String, dynamic> json) {
    return PlayerFineDetails(
      id: json['id'],
      playerDetails: PlayerDetails.fromJson(json['playerDetails']),
      fineTypeDetails: FineTypeDetails.fromJson(json['fineTypeDetails']),
      owedAmount: json['owedAmount'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
