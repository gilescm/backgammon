import 'package:backgammon/components/component_enums.dart';

enum MovementType { exact, atMost }

mixin BackgammonGameState {
  PieceOwner currentTurn = PieceOwner.player;
  final List<int> dieValues = [0, 0];

  bool get hasRolled => _totalRolled != 0;

  int get _totalRolled => dieValues.fold<int>(0, (total, die) => total + die);

  bool canMoveDistance(int distance, {MovementType type = MovementType.exact}) {
    switch (type) {
      case MovementType.exact:
        return distance == dieValues.first || distance == dieValues.last || distance == _totalRolled;
      case MovementType.atMost:
        return distance <= _totalRolled;
    }
  }

  void updateMovementStats(int distance, {MovementType type = MovementType.exact}) {
    assert(hasRolled);

    switch (type) {
      case MovementType.exact:
        if (distance == dieValues.first) {
          dieValues[0] = 0;
        } else if (distance == dieValues.last) {
          dieValues[1] = 0;
        } else if (distance == _totalRolled) {
          dieValues[0] = 0;
          dieValues[1] = 0;
        }
      case MovementType.atMost:
        dieValues.sort((a, b) => a - b);
        if (distance <= dieValues.first) {
          dieValues[0] = 0;
        } else if (distance > dieValues.first && distance <= dieValues.last) {
          dieValues[1] = 0;
        } else if (distance <= _totalRolled) {
          dieValues[0] = 0;
          dieValues[1] = 0;
        }
    }
  }

  void maybeEndTurn(PieceOwner owner) {
    if (currentTurn == owner && _totalRolled == 0) {
      currentTurn = currentTurn.other;
      dieValues.clear();
      dieValues.addAll([0, 0]);
    }
  }
}
