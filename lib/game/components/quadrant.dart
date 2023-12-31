import 'dart:math' as math;

import 'package:backgammon/game/backgammon_game.dart';
import 'package:backgammon/game/components/component_enums.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Quadrant extends PositionComponent {
  Quadrant({required this.type, super.position}) : super(size: BackgammonGame.quadrantSize);

  final QuadrantType type;

  static final _sprite = backgammonSprite(
    SpriteAssetType.board,
    x: 17,
    y: 127,
    width: 94,
    height: 97,
  );

  @override
  void render(Canvas canvas) {
    final shouldRotate = type.isTop;

    if (shouldRotate) {
      canvas.save();
      canvas.translate(size.x / 2, size.y / 2);
      canvas.rotate(math.pi);
      canvas.translate(-size.x / 2, -size.y / 2);
    }

    _sprite.render(
      canvas,
      position: Vector2.zero(),
      size: size,
    );

    if (shouldRotate) {
      canvas.restore();
    }
  }
}
