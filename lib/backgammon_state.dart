import 'package:backgammon/components/component_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MovementType { exact, atMost }

final backgammonStateProvider = StateNotifierProvider<BackgammonStateNotifier, BackgammonGameState>(
  (ref) => BackgammonStateNotifier(),
);

class BackgammonGameState {
  BackgammonGameState._({
    required this.currentTurn,
    required this.dieValues,
  }) : assert(dieValues.length == 2);

  Player currentTurn;
  List<int> dieValues;

  int get totalRolled => dieValues.fold<int>(0, (total, die) => total + die);

  bool canMovePiece(Player owner) => totalRolled != 0 && currentTurn == owner;

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
  }) {
    return BackgammonGameState._(
      currentTurn: player ?? currentTurn,
      dieValues: dieValues ?? this.dieValues,
    );
  }
}

class BackgammonStateNotifier extends StateNotifier<BackgammonGameState> {
  BackgammonStateNotifier() : super(BackgammonGameState._(currentTurn: Player.player, dieValues: [0, 0]));

  void updateDieValues(List<int> values) {
    state = state.copyWith(dieValues: values);
  }

  void maybeEndTurn(Player owner) {
    if (state.currentTurn == owner && state.totalRolled == 0) {
      state = state.copyWith(
        player: state.currentTurn.other,
        dieValues: [0, 0],
      );
    }
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
        if (distance <= state.dieValues.first) {
          dieValues[0] = 0;
        } else if (distance > state.dieValues.first && distance <= state.dieValues.last) {
          dieValues[1] = 0;
        } else if (distance <= state.totalRolled) {
          dieValues[0] = 0;
          dieValues[1] = 0;
        }
    }

    state = state.copyWith(dieValues: dieValues);
  }
}
