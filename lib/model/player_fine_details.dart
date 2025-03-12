import 'package:klubhuset/model/fine_details.dart';
import 'package:klubhuset/model/player_details.dart';

class PlayerFineDetails {
  final int id;
  final PlayerDetails playerDetails;
  final List<FineDetails> fineDetailsList;

  PlayerFineDetails({
    required this.id,
    required this.playerDetails,
    required this.fineDetailsList,
  });

  factory PlayerFineDetails.fromJson(Map<String, dynamic> json) {
    return PlayerFineDetails(
      id: json['id'],
      playerDetails: PlayerDetails.fromJson(json['playerDetails']),
      fineDetailsList: json['fineDetailsList'] != null
          ? List<FineDetails>.from(
              json['fineDetailsList'].map((x) => FineDetails.fromJson(x)))
          : [],
    );
  }
}
