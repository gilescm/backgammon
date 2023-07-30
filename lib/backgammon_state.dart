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

  PieceOwner currentTurn;
  List<int> dieValues;

  BackgammonGameState copyWith({
    PieceOwner? player,
    List<int>? dieValues,
  }) {
    return BackgammonGameState._(
      currentTurn: player ?? currentTurn,
      dieValues: dieValues ?? this.dieValues,
    );
  }
}

class BackgammonStateNotifier extends StateNotifier<BackgammonGameState> {
  BackgammonStateNotifier() : super(BackgammonGameState._(currentTurn: PieceOwner.player, dieValues: [0, 0]));

  void updateDieValues(List<int> values) {
    state = state.copyWith(dieValues: values);
  }

  void maybeEndTurn(PieceOwner owner) {
    if (state.currentTurn == owner && _totalRolled == 0) {
      state = state.copyWith(
        player: state.currentTurn.other,
        dieValues: [0, 0],
      );
    }
  }

  bool canMovePiece(PieceOwner owner) => _totalRolled != 0 && state.currentTurn == owner;

  bool canMoveDistance(int distance, {MovementType type = MovementType.exact}) {
    switch (type) {
      case MovementType.exact:
        return distance == state.dieValues.first || distance == state.dieValues.last || distance == _totalRolled;
      case MovementType.atMost:
        return distance <= _totalRolled;
    }
  }

  void updateMovementStats(int distance, {MovementType type = MovementType.exact}) {
    assert(_totalRolled != 0);

    switch (type) {
      case MovementType.exact:
        if (distance == state.dieValues.first) {
          state.dieValues[0] = 0;
        } else if (distance == state.dieValues.last) {
          state.dieValues[1] = 0;
        } else if (distance == _totalRolled) {
          state.dieValues[0] = 0;
          state.dieValues[1] = 0;
        }
      case MovementType.atMost:
        state.dieValues.sort((a, b) => a - b);
        if (distance <= state.dieValues.first) {
          state.dieValues[0] = 0;
        } else if (distance > state.dieValues.first && distance <= state.dieValues.last) {
          state.dieValues[1] = 0;
        } else if (distance <= _totalRolled) {
          state.dieValues[0] = 0;
          state.dieValues[1] = 0;
        }
    }
  }

  int get _totalRolled => state.dieValues.fold<int>(0, (total, die) => total + die);
}
