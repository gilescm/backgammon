part of 'piece_location.dart';

/// This is purgatory/jail for the pieces. Captured pieces come
/// here and wait for a lucky roll to be released
class Bar extends PieceLocation with HasComponentRef {
  Bar()
      : super(
          position: Vector2(BackgammonGame.quadrantSize.x, BackgammonGame.pointSize.y),
          size: BackgammonGame.barSize,
        );

  final List<Piece> _pieces = [];

  static final _sprite = backgammonSprite(
    SpriteAssetType.board,
    x: 112,
    y: 16,
    width: 16,
    height: 208,
  );

  bool containsPiecesFor(Player owner) => _pieces.any((piece) => piece.owner == owner);

  @override
  void acquirePiece(Piece piece) {
    piece.location = this;

    final gameNotifier = ref.read(backgammonStateProvider.notifier);
    gameNotifier.updatePlayerWithPiecesInBar(piece.owner, type: BarMovementType.capturing);

    _pieces.add(piece);
    _positionPieces();
  }

  @override
  void removePiece(Piece piece) {
    final gameNotifier = ref.read(backgammonStateProvider.notifier);
    gameNotifier.updatePlayerWithPiecesInBar(piece.owner, type: BarMovementType.escaping);

    _pieces.remove(piece);
    _positionPieces();
  }

  @override
  void returnPiece(Piece piece) {
    final gameNotifier = ref.read(backgammonStateProvider.notifier);
    gameNotifier.updatePlayerWithPiecesInBar(piece.owner, type: BarMovementType.escaping);

    piece.priority = _pieces.length;
    _positionPieces();
  }

  @override
  void render(Canvas canvas) {
    _sprite.render(
      canvas,
      position: Vector2.zero(),
      size: size,
    );
  }

  void _positionPieces() {
    final playerPieces = _pieces.where((piece) => piece.owner.isPlayer).toList();
    final opponentPieces = _pieces.where((piece) => !piece.owner.isPlayer).toList();
    _positionOwnersPieces(playerPieces);
    _positionOwnersPieces(opponentPieces);
  }

  void _positionOwnersPieces(List<Piece> pieces) {
    if (pieces.isEmpty) {
      return;
    }

    final firstPiece = pieces[0];
    final middlePosition = Vector2(
      position.x + size.x / 2 - firstPiece.size.x / 2,
      position.y + size.y / 2 - firstPiece.size.y + firstPiece.size.y * firstPiece.owner.direction * 2,
    );

    firstPiece.priority = 1;
    firstPiece.position.setFrom(middlePosition);

    if (pieces.length > 1) {
      for (var i = 1; i < pieces.length; i++) {
        pieces[i].priority = pieces[i - 1].priority + i;
        pieces[i].position
          ..setFrom(pieces[i - 1].position)
          ..add(Vector2(0, pieces[i].size.y * (1 / 3) * firstPiece.owner.direction));
      }
    }
  }
}
