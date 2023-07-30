part of 'piece_location.dart';

class Point extends PieceLocation {
  Point({required this.order, super.position, super.size});

  @override
  bool get debugMode => false;

  final int order;
  final List<Piece> _pieces = [];

  bool isTopPiece(Piece piece) => _pieces.isEmpty || _pieces.last == piece;

  bool canAcceptPiece(Piece piece) {
    return _pieces.where((p) => p.owner != piece.owner).length < 2 && _pieces.length < BackgammonGame.maxPiecesPerPoint;
  }

  @override
  void acquirePiece(Piece piece) {
    assert(canAcceptPiece(piece));
    assert(!canSendExistingPieceToBar(piece), 'This point shouldn\'t acquire a different owners piece right now');

    piece.priority = _pieces.length;
    piece.location = this;

    _pieces.add(piece);
    _positionPieces();
  }

  @override
  void removePiece(Piece piece) {
    _pieces.remove(piece);
    _positionPieces();
  }

  @override
  void returnPiece(Piece piece) {
    piece.priority = _pieces.length;
    _positionPieces();
  }

  bool canSendExistingPieceToBar(Piece piece) => _pieces.length == 1 && _pieces.first.owner != piece.owner;

  void swapOpposingPieces(Piece piece) {
    assert(canAcceptPiece(piece));
    assert(canSendExistingPieceToBar(piece));

    final opposingPiece = _pieces.first;
    _worldBar.acquirePiece(opposingPiece);
    _pieces.clear();

    acquirePiece(piece);
  }

  Bar get _worldBar => parent!.children.whereType<Bar>().first;

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
      position.x + size.x / 2 - firstPiece.size.x / 2,
      isInTopHalf ? position.y : position.y + size.y - firstPiece.size.y,
    );

    firstPiece.position.setFrom(middlePosition);
    for (var i = 1; i < _pieces.length; i++) {
      _pieces[i].position
        ..setFrom(_pieces[i - 1].position)
        ..add(Vector2(0, (isInTopHalf ? 1 : -1) * _pieces[i].size.y));
    }
  }
}
