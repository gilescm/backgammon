import 'dart:ui';

import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/components/piece.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';

class WinPile extends PositionComponent {
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
  void render(Canvas canvas) {
    _sprite.render(
      canvas,
      position: Vector2(0, 0),
      size: size,
      overridePaint: _blueFilter,
    );
  }
}
