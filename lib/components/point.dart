import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/components/piece.dart';
import 'package:backgammon/components/quadrant.dart';
import 'package:flame/components.dart';

class Point extends PositionComponent {
  Point({
    required this.order,
    super.position,
    super.size,
  });

  @override
  bool get debugMode => false;

  final int order;
  final List<Piece> _pieces = [];

  void acquirePiece(Piece piece) {
    assert(_pieces.length <= BackgammonGame.maxPiecesPerPoint);

    piece.priority = _pieces.length;
    piece.point = this;

    _pieces.add(piece);
    _positionPieces();
  }

  void removePiece(Piece piece) {
    _pieces.remove(piece);
    _positionPieces();
  }

  QuadrantType get _currentQuadrantType {
    final nearbyPoints = parent!.componentsAtPoint(position + size / 2).whereType<Quadrant>().toList();
    return nearbyPoints.first.type;
  }

  void _positionPieces() {
    if (_pieces.isEmpty) {
      return;
    }

    final isInTopHalf = _currentQuadrantType.isTop;
    final firstPiece = _pieces[0];
    final middlePosition = Vector2(
      position.x + BackgammonGame.pointSize.x / 2 - firstPiece.size.x / 2,
      isInTopHalf ? position.y : position.y + size.y - firstPiece.size.y,
    );

    firstPiece.position.setFrom(middlePosition);
    for (var i = 1; i < _pieces.length; i++) {
      _pieces[i].position
        ..setFrom(_pieces[i - 1].position)
        ..add(Vector2(0, (isInTopHalf ? 1 : -1) * _pieces[i].size.y));
    }

    // height = KlondikeGame.cardHeight * 1.5 + cards.last.y - cards.first.y;
  }
}
