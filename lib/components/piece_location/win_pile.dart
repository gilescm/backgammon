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
    throw StateError('Implement');
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
      position: Vector2(0, 0),
      size: size,
      overridePaint: _blueFilter,
    );
  }
}
