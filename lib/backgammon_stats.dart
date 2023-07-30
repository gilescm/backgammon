import 'package:backgammon/components/component_enums.dart';

mixin BackgammonGameStats {
  PieceOwner currentTurn = PieceOwner.player;
  final List<int> dieValues = [0, 0];

  bool get hasRolled => _totalRolled != 0;

  int get _totalRolled => dieValues.fold<int>(0, (total, die) => total + die);
}
