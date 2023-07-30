import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/components/component_enums.dart';
import 'package:backgammon/components/piece_location/piece_location.dart';
import 'package:backgammon/utils/position_component_utils.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class Piece extends PositionComponent with DragCallbacks {
  Piece({
    required this.owner,
    required this.color,
    required PieceLocation location,
    super.position,
  })  : assert(_sprites.containsKey(color)),
        _location = location,
        _sprite = _sprites[color]!,
        super(size: BackgammonGame.pieceSize);

  final PieceOwner owner;
  final PieceColor color;
  final Sprite _sprite;

  PieceLocation get location => _location;
  PieceLocation _location;
  set location(PieceLocation value) {
    _location.removePiece(this);
    _location = value;
  }

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
  void onDragStart(DragStartEvent event) {
    switch (_location) {
      case final Bar _:
        break;
      case final WinPile _:
        // You cannot move pieces from the win pile (and you shouldn't want to!)
        return;
      case final Point point:
        if (_worldBar.containsPiecesFor(owner)) {
          return;
        }

        point.visuallyRemovePiece(this);
        break;
    }

    super.onDragStart(event);
  }

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

    var isMoving = false;
    final nearbyLocation = parent!.componentsAtPoint(position + size / 2).whereType<PieceLocation>().toList();
    if (nearbyLocation.isNotEmpty) {
      final closestLocation = nearbyLocation.first;
      switch (closestLocation) {
        case final Bar _:
          // Manual placement onto the bar is not allowed
          break;
        case final Point point:
          if (point.canSendExistingPieceToBar(this)) {
            point.swapOpposingPieces(this);
            isMoving = true;
          } else if (point.canAcceptPiece(this)) {
            point.acquirePiece(this);
            isMoving = true;
          }
          break;
        case final WinPile winPile:
          winPile.acquirePiece(this);
          break;
      }
    }

    if (!isMoving) {
      location.returnPiece(this);
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

  Bar get _worldBar => parent!.children.whereType<Bar>().first;
}
