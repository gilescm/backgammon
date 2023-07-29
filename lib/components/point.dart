import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/components/piece.dart';
import 'package:backgammon/components/quadrant.dart';
import 'package:flame/components.dart';

class Point extends PositionComponent {
  Point({
    required this.order,
    super.position,
  });

  final int order;

  final List<Piece> pieces = [];

  void acquirePiece(Piece piece) {
    piece.position = Vector2(
      position.x + BackgammonGame.pointSize.x / 2 - piece.size.x / 2,
      _currentQuadrantType.isTop ? position.y : position.y + size.y - piece.size.y,
    );

    piece.priority = pieces.length;
    piece.point = this;
    pieces.add(piece);
  }

  void removePiece(Piece piece) {
    pieces.remove(piece);
  }

  @override
  bool get debugMode => true;

  QuadrantType get _currentQuadrantType {
    final nearbyPoints = parent!.componentsAtPoint(position + size / 2).whereType<Quadrant>().toList();
    return nearbyPoints.first.type;
  }
}
