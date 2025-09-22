enum CardType { yellow, red, secondYellow }

extension CardTypeWire on CardType {
  String get wire => const {
        CardType.yellow: 'YELLOW',
        CardType.red: 'RED',
        CardType.secondYellow: 'SECOND_YELLOW',
      }[this]!;
}
