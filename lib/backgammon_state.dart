import 'package:backgammon/components/component_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backgammonStateProvider = StateNotifierProvider<BackgammonStateNotifier, BackgammonGameState>(
  (ref) => BackgammonStateNotifier(),
);

class BackgammonStateNotifier extends StateNotifier<BackgammonGameState> {
  BackgammonStateNotifier() : super(BackgammonGameState(startingTurn: PieceOwner.player));
}

enum MovementType { exact, atMost }

class BackgammonGameState {
  BackgammonGameState({
    required PieceOwner startingTurn,
  })  : _currentTurn = startingTurn,
        _dieValues = [0, 0];

  late PieceOwner _currentTurn;
  late final List<int> _dieValues;

  void updateDieValues(Iterable<int> values) {
    _dieValues.clear();
    _dieValues.addAll(values);
  }

  bool canMovePiece(PieceOwner owner) => _totalRolled != 0 && _currentTurn == owner;

  bool canMoveDistance(int distance, {MovementType type = MovementType.exact}) {
    switch (type) {
      case MovementType.exact:
        return distance == _dieValues.first || distance == _dieValues.last || distance == _totalRolled;
      case MovementType.atMost:
        return distance <= _totalRolled;
    }
  }

  void updateMovementStats(int distance, {MovementType type = MovementType.exact}) {
    assert(_totalRolled != 0);

    switch (type) {
      case MovementType.exact:
        if (distance == _dieValues.first) {
          _dieValues[0] = 0;
        } else if (distance == _dieValues.last) {
          _dieValues[1] = 0;
        } else if (distance == _totalRolled) {
          _dieValues[0] = 0;
          _dieValues[1] = 0;
        }
      case MovementType.atMost:
        _dieValues.sort((a, b) => a - b);
        if (distance <= _dieValues.first) {
          _dieValues[0] = 0;
        } else if (distance > _dieValues.first && distance <= _dieValues.last) {
          _dieValues[1] = 0;
        } else if (distance <= _totalRolled) {
          _dieValues[0] = 0;
          _dieValues[1] = 0;
        }
    }
  }

  void maybeEndTurn(PieceOwner owner) {
    if (_currentTurn == owner && _totalRolled == 0) {
      _currentTurn = _currentTurn.other;
      _dieValues.clear();
      _dieValues.addAll([0, 0]);
    }
  }

  int get _totalRolled => _dieValues.fold<int>(0, (total, die) => total + die);
}
