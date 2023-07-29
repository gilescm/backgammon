import 'dart:math' as math;

import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/components/piece.dart';
import 'package:backgammon/components/point.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum QuadrantType {
  topLeft([(PieceOwner.player, 5), (null, 0), (null, 0), (null, 0), (PieceOwner.opponent, 3), (null, 0)]),
  topRight([(PieceOwner.opponent, 5), (null, 0), (null, 0), (null, 0), (null, 0), (PieceOwner.player, 2)]),
  bottomLeft([(PieceOwner.opponent, 5), (null, 0), (null, 0), (null, 0), (PieceOwner.player, 3), (null, 0)]),
  bottomRight([(PieceOwner.player, 5), (null, 0), (null, 0), (null, 0), (null, 0), (PieceOwner.opponent, 2)]);

  const QuadrantType(this.startingPositions);

  final List<(PieceOwner?, int)> startingPositions;

  bool get isTop => this == topLeft || this == topRight;

  bool get isBottom => this == bottomLeft || this == bottomRight;
}

class Quadrant extends PositionComponent {
  Quadrant({required this.type, super.position}) : super(size: BackgammonGame.quadrantSize);

  final QuadrantType type;
  final List<Point> points = [];

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
      position: Vector2(0, 0),
      size: size,
    );

    if (shouldRotate) {
      canvas.restore();
    }
  }
}
