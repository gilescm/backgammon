part of 'piece_location.dart';

class Point extends PieceLocation {
  Point({
    required QuadrantType quadrantType,
    required int order,
    super.position,
    super.size,
  })  : _quadrantType = quadrantType,
        _order = order;

  final QuadrantType _quadrantType;
  final int _order;
  final List<Piece> _visiblePieces = [];
  final List<Piece> _pieces = [];

  bool isInValidDirectionFor(Piece piece) {
    final owner = piece.owner;
    switch (piece.location) {
      case final WinPile _:
        throw StateError('Cannot move pieces from win pile onto points');
      case final Bar _:
        return _quadrantType.isStartingQuadrantFor(owner);
      case final Point currentPoint:
        final isInSameQuadrant = currentPoint._quadrantType == _quadrantType;
        if (isInSameQuadrant) {
          final diff = _order - currentPoint._order;
          return owner.isPlayer ? diff > 0 : diff < 0;
        }

        if (_quadrantType.isNextQuadrantFor(owner, currentPoint._quadrantType)) {
          return true;
        }

        return false;
    }

    final pieceDirection = piece.owner.direction;
    return true;
  }

  bool canAcceptPiece(Piece piece) {
    return _pieces.where((p) => p.owner != piece.owner).length < 2 && _pieces.length < BackgammonGame.maxPiecesPerPoint;
  }

  @override
  void acquirePiece(Piece piece) {
    assert(canAcceptPiece(piece), 'This point cannot acquire a different owners piece right now');
    assert(!canSendExistingPieceToBar(piece));

    piece.priority = _pieces.length;
    piece.location = this;

    _pieces.add(piece);
    _visiblePieces.add(piece);
    _positionPieces();
  }

  @override
  void removePiece(Piece piece) {
    _pieces.remove(piece);
    _visiblePieces.remove(piece);
    _positionPieces();
  }

  @override
  void returnPiece(Piece piece) {
    assert(!_visiblePieces.contains(piece), 'Can only visually return piece if it is not already there');

    piece.priority = _pieces.length;
    _visiblePieces.add(piece);
    _positionPieces();
  }

  void visuallyRemovePiece(Piece piece) {
    _visiblePieces.remove(piece);
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
    if (_visiblePieces.isEmpty) {
      return;
    }

    final isInTopHalf = _currentQuadrantType.isTop;
    final firstPiece = _visiblePieces[0];
    final middlePosition = Vector2(
      position.x + size.x / 2 - firstPiece.size.x / 2,
      isInTopHalf ? position.y : position.y + size.y - firstPiece.size.y,
    );

    firstPiece.position.setFrom(middlePosition);
    for (var i = 1; i < _visiblePieces.length; i++) {
      _visiblePieces[i].position
        ..setFrom(_visiblePieces[i - 1].position)
        ..add(Vector2(0, (isInTopHalf ? 1 : -1) * _visiblePieces[i].size.y));
    }
  }
}
