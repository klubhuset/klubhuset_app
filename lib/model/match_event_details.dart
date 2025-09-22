import 'package:klubhuset/model/card_type.dart';
import 'package:klubhuset/model/match_event_type.dart';

class MatchEventDetails {
  final int id;
  final int matchId;
  final MatchEventType type;
  final int teamId;
  final int goalscorerUserId;
  final String goalscorerUserName;
  final int? assistMakerUserId;
  final String? assistMakerUserName;
  final CardType? cardType;

  MatchEventDetails({
    required this.id,
    required this.matchId,
    required this.type,
    required this.teamId,
    required this.goalscorerUserId,
    required this.goalscorerUserName,
    this.assistMakerUserId,
    this.assistMakerUserName,
    this.cardType,
  });

  factory MatchEventDetails.fromJson(Map<String, dynamic> json) {
    return MatchEventDetails(
      id: json['id'],
      matchId: json['matchId'],
      type: MatchEventType.values.firstWhere((e) => e.wire == json['type']),
      teamId: json['teamId'],
      goalscorerUserId: json['goalscorerUserId'],
      goalscorerUserName: json['goalscorerUserName'],
      assistMakerUserId: json['assistMakerUserId'],
      assistMakerUserName: json['assistMakerUserName'],
      cardType: json['cardType'] != null
          ? CardType.values.firstWhere((e) => e.wire == json['cardType'])
          : null,
    );
  }
}
