import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:klubhuset/model/player_vote.dart';

class PlayerVotesState extends ChangeNotifier {
  final List<PlayerVote> _playerVotes = [];

  PlayerVotesState();

  UnmodifiableListView<PlayerVote> get playerVotes =>
      UnmodifiableListView(_playerVotes);

  void addPlayerVote(PlayerVote playerVote) {
    bool doesPlayerHaveNotVotesYet =
        !_playerVotes.any((x) => x.playerId == playerVote.playerId);

    if (doesPlayerHaveNotVotesYet) {
      _playerVotes.add(playerVote);
      notifyListeners();
    } else {
      updatePlayerVote(playerVote.playerId, playerVote.votes);
    }
  }

  void updatePlayerVote(int playerId, int votes) {
    if (votes == 0) {
      _playerVotes.removeWhere((x) => x.playerId == playerId);
    } else {
      _playerVotes[_playerVotes.indexWhere((x) => x.playerId == playerId)]
          .setVotes(votes);
    }

    notifyListeners();
  }

  void removeAllPlayerVotes() {
    _playerVotes.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
