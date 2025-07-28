class RegisterForUnregisterFromMatchCommand {
  String matchId;

  RegisterForUnregisterFromMatchCommand({required this.matchId});

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
    };
  }
}
