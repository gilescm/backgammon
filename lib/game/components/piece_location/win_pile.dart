part of 'piece_location.dart';

class WinPile extends PieceLocation {
  WinPile()
      : super(
          position: Vector2(
            BackgammonGame.quadrantSize.x * 2 + BackgammonGame.barSize.x,
            BackgammonGame.pointSize.y,
          ),
          size: BackgammonGame.barSize,
        );

  final List<Piece> _pieces = [];

  static final _blueFilter = Paint()..colorFilter = const ColorFilter.mode(Color(0x880d8bff), BlendMode.srcATop);
  static final _sprite = backgammonSprite(
    SpriteAssetType.board,
    x: 112,
    y: 16,
    width: 16,
    height: 208,
  );

  @override
  void acquirePiece(Piece piece) {
    piece.location = this;

    _pieces.add(piece);
    _positionPieces();
  }

  @override
  void removePiece(Piece piece) => throw StateError('Pieces cannot leave the win pile');

  @override
  void returnPiece(Piece piece) {
    throw StateError('Pieces cannot leave the win pile so its illogical to attempt return');
  }

  @override
  void render(Canvas canvas) {
    _sprite.render(
      canvas,
      position: Vector2.zero(),
      size: size,
      overridePaint: _blueFilter,
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
      position.y + size.y / 2 - firstPiece.size.y / 2 + firstPiece.size.y / 2 * -firstPiece.owner.direction,
    );

    firstPiece.priority = 1;
    firstPiece.position.setFrom(middlePosition);

    if (pieces.length > 1) {
      for (var i = 1; i < pieces.length; i++) {
        pieces[i].priority = pieces[i - 1].priority + i;
        pieces[i].position
          ..setFrom(pieces[i - 1].position)
          ..add(Vector2(0, pieces[i].size.y * (1 / 3) * -firstPiece.owner.direction));
      }
    }
  }
}
