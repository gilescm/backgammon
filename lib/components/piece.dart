import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/components/point.dart';
import 'package:backgammon/utils/position_component_utils.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

enum PieceOwner {
  player,
  opponent;

  bool get isPlayer => this == player;
}

enum PieceColor { silver, white, red, green, yellow, emerald, purple, blue, orange }

class Piece extends PositionComponent with DragCallbacks {
  Piece({
    required this.owner,
    required this.color,
    this.point,
    super.position,
  })  : assert(_sprites.containsKey(color)),
        _sprite = _sprites[color]!,
        super(size: BackgammonGame.pieceSize);

  final PieceOwner owner;
  final PieceColor color;
  final Sprite _sprite;

  Point? point;

  static final Map<PieceColor, Sprite> _sprites = {
    PieceColor.silver: backgammonSprite(SpriteAssetType.piece, x: 1, y: 18, width: 14, height: 16),
    PieceColor.white: backgammonSprite(SpriteAssetType.piece, x: 1, y: 66, width: 14, height: 16),
    PieceColor.red: backgammonSprite(SpriteAssetType.piece, x: 1, y: 114, width: 14, height: 16),
    PieceColor.green: backgammonSprite(SpriteAssetType.piece, x: 1, y: 162, width: 14, height: 16),
    PieceColor.yellow: backgammonSprite(SpriteAssetType.piece, x: 1, y: 210, width: 14, height: 16),
    PieceColor.emerald: backgammonSprite(SpriteAssetType.piece, x: 1, y: 258, width: 14, height: 16),
    PieceColor.purple: backgammonSprite(SpriteAssetType.piece, x: 1, y: 306, width: 14, height: 16),
    PieceColor.blue: backgammonSprite(SpriteAssetType.piece, x: 1, y: 354, width: 14, height: 16),
    PieceColor.orange: backgammonSprite(SpriteAssetType.piece, x: 1, y: 402, width: 14, height: 16),
  };

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDragged) {
      return;
    }

    priority = 100;
    final delta = event.delta / cameraZoomLevel;
    position += delta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!isDragged) {
      return;
    }

    final point = this.point;
    if (point == null) {
      return;
    }

    final nearbyPoints = parent!.componentsAtPoint(position + size / 2).whereType<Point>().toList();
    if (nearbyPoints.isNotEmpty) {
      point.removePiece(this);
      final closestPoint = nearbyPoints.first;
      closestPoint.acquirePiece(this);
    }

    super.onDragEnd(event);
  }

  @override
  void render(Canvas canvas) {
    _sprite.render(
      canvas,
      position: Vector2(0, size.y / 2),
      size: size,
      anchor: Anchor.centerLeft,
    );
  }
}
