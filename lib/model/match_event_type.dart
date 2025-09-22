enum MatchEventType { goal, card }

extension MatchEventTypeWire on MatchEventType {
  String get wire => const {
        MatchEventType.goal: 'GOAL',
        MatchEventType.card: 'CARD',
      }[this]!;
}
