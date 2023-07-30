import 'package:backgammon/components/component_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MovementType { exact, atMost }

enum BarMovementType { capturing, escaping }

final backgammonStateProvider = StateNotifierProvider<BackgammonStateNotifier, BackgammonGameState>(
  (ref) => BackgammonStateNotifier(),
);

class BackgammonGameState {
  BackgammonGameState._({
    required this.currentPlayer,
    required this.dieValues,
    required this.playersWithPieceInBar,
  }) : assert(dieValues.length == 2);

  Player currentPlayer;
  List<int> dieValues;
  Set<Player> playersWithPieceInBar;

  bool get doesCurrentPlayerHavePieceInBar => playersWithPieceInBar.contains(currentPlayer);

  int get totalRolled => dieValues.fold<int>(0, (total, die) => total + die);

  bool canMovePiece(Player owner) => totalRolled != 0 && currentPlayer == owner;

  bool canMoveDistance(int distance, {MovementType type = MovementType.exact}) {
    switch (type) {
      case MovementType.exact:
        return distance == dieValues.first || distance == dieValues.last || distance == totalRolled;
      case MovementType.atMost:
        return distance <= totalRolled;
    }
  }

  BackgammonGameState copyWith({
    Player? player,
    List<int>? dieValues,
    Set<Player>? playersWithPieceInBar,
  }) {
    return BackgammonGameState._(
      currentPlayer: player ?? currentPlayer,
      dieValues: dieValues ?? this.dieValues,
      playersWithPieceInBar: playersWithPieceInBar ?? this.playersWithPieceInBar,
    );
  }
}

class BackgammonStateNotifier extends StateNotifier<BackgammonGameState> {
  BackgammonStateNotifier()
      : super(
          BackgammonGameState._(
            currentPlayer: Player.player,
            dieValues: [0, 0],
            playersWithPieceInBar: {},
          ),
        );
  void endTurn() {
    state = state.copyWith(
      player: state.currentPlayer.other,
      dieValues: [0, 0],
    );
  }

  void maybeEndTurn(Player currentPlayer) {
    if (state.currentPlayer == currentPlayer && state.totalRolled == 0) {
      endTurn();
    }
  }

  void updatePlayerWithPiecesInBar(Player player, {required BarMovementType type}) {
    switch (type) {
      case BarMovementType.capturing:
        final players = {...state.playersWithPieceInBar, player};
        state = state.copyWith(playersWithPieceInBar: players);

      case BarMovementType.escaping:
        final players = {...state.playersWithPieceInBar..remove(player)};
        state = state.copyWith(playersWithPieceInBar: players);
    }
  }

  void updateDieValues(List<int> values) {
    state = state.copyWith(dieValues: values);
  }

  void updateMovementStats(int distance, {MovementType type = MovementType.exact}) {
    assert(state.totalRolled != 0);

    final dieValues = List<int>.from(state.dieValues);
    switch (type) {
      case MovementType.exact:
        if (distance == state.dieValues.first) {
          dieValues[0] = 0;
        } else if (distance == state.dieValues.last) {
          dieValues[1] = 0;
        } else if (distance == state.totalRolled) {
          dieValues[0] = 0;
          dieValues[1] = 0;
        }
      case MovementType.atMost:
        dieValues.sort((a, b) => a - b);
        final smallValue = state.dieValues.first;
        final bigValue = state.dieValues.last;
        if (smallValue == 0 && bigValue == 0) {
          return;
        }

        if (smallValue != 0 && bigValue != 0) {
          if (distance <= smallValue) {
            dieValues[0] = 0;
          } else if (distance > smallValue && distance < bigValue) {
            dieValues[1] = 0;
          } else if (distance == bigValue) {
            dieValues[1] = 0;
          } else if (distance <= (smallValue + bigValue)) {
            dieValues[0] = 0;
            dieValues[1] = 0;
          }
        }

        if (smallValue != 0 && bigValue == 0) {
          if (distance <= smallValue) {
            dieValues[0] = 0;
          }
        }

        if (smallValue == 0 && bigValue != 0) {
          if (distance <= bigValue) {
            dieValues[1] = 0;
          }
        }
    }

    state = state.copyWith(dieValues: dieValues);
  }
}
