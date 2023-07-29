import 'dart:ui';

import 'package:backgammon/components/piece.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';

/// This is purgatory/jail for the pieces. Captured pieces come
/// here and wait for a lucky roll to be released
class Bar extends PositionComponent {
  Bar({super.position, super.size});

  final List<Piece> _pieces = [];

  static final _sprite = backgammonSprite(
    SpriteAssetType.board,
    x: 112,
    y: 16,
    width: 16,
    height: 208,
  );

  void acquirePiece(Piece piece) {
    piece.priority = _pieces.length;
    piece.bar = this;
    piece.point = null;

    _pieces.add(piece);
    _positionPieces();
  }

  void removePiece(Piece piece) {
    _pieces.remove(piece);
    _positionPieces();
  }

  @override
  void render(Canvas canvas) {
    _sprite.render(
      canvas,
      position: Vector2(0, 0),
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
      position.y + size.y / 2 - firstPiece.size.y / 2 + firstPiece.size.y / 2 * firstPiece.owner.barDirection,
    );

    firstPiece.position.setFrom(middlePosition);

    if (pieces.length > 1) {
      for (var i = 1; i < pieces.length; i++) {
        pieces[i].position
          ..setFrom(pieces[i - 1].position)
          ..add(Vector2(0, pieces[i].size.y * (1 / 3) * firstPiece.owner.barDirection));
      }
    }
  }
}
