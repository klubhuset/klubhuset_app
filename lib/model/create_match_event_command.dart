import 'package:klubhuset/model/card_type.dart';
import 'package:klubhuset/model/match_event_type.dart';

class CreateMatchEventCommand {
  final int matchId;
  final MatchEventType type;
  final int teamId;
  final int goalscorerUserId;
  final int? assistMakerUserId;
  final CardType? cardType;

  CreateMatchEventCommand({
    required this.matchId,
    required this.type,
    required this.teamId,
    required this.goalscorerUserId,
    this.assistMakerUserId,
    this.cardType,
  });

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'type': type.wire,
      'teamId': teamId,
      'goalscorerUserId': goalscorerUserId,
      if (assistMakerUserId != null) 'assistMakerUserId': assistMakerUserId,
      if (cardType != null) 'cardType': cardType!.wire,
    };
  }
}
