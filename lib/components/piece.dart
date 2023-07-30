import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/backgammon_state.dart';
import 'package:backgammon/components/component_enums.dart';
import 'package:backgammon/components/piece_location/piece_location.dart';
import 'package:backgammon/utils/position_component_utils.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';

class Piece extends PositionComponent with DragCallbacks, HasComponentRef {
  Piece({
    required this.owner,
    required PieceLocation location,
    super.position,
  })  : assert(pieceSprites.containsKey(owner.pieceColor)),
        color = owner.pieceColor,
        _location = location,
        _sprite = backgammonSprite(
          pieceSprites[owner.pieceColor]!.type,
          x: pieceSprites[owner.pieceColor]!.x,
          y: pieceSprites[owner.pieceColor]!.y,
          width: pieceSprites[owner.pieceColor]!.width,
          height: pieceSprites[owner.pieceColor]!.height,
        ),
        super(size: BackgammonGame.pieceSize);

  final Player owner;
  final PieceColor color;
  final Sprite _sprite;

  PieceLocation get location => _location;
  PieceLocation _location;
  set location(PieceLocation value) {
    _location.removePiece(this);
    _location = value;
  }

  @override
  void onDragStart(DragStartEvent event) {
    final gameState = ref.read(backgammonStateProvider);
    if (!gameState.canMovePiece(owner)) {
      return;
    }

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

    final gameState = ref.read(backgammonStateProvider);
    final gameNotifier = ref.read(backgammonStateProvider.notifier);

    var isMoving = false;
    final nearbyLocation = parent!.componentsAtPoint(position + size / 2).whereType<PieceLocation>().toList();
    if (nearbyLocation.isNotEmpty) {
      final closestLocation = nearbyLocation.first;
      switch (closestLocation) {
        case final Bar _:
          // Manual placement onto the bar is not allowed
          break;
        case final Point point:
          final currentOrder = _location.locationOrder(owner);
          final diff = owner.isPlayer ? point.order - currentOrder : currentOrder - point.order;
          final canMoveDistance = gameState.canMoveDistance(diff);

          if (canMoveDistance && point.isValidNextMoveFor(this)) {
            gameNotifier.updateMovementStats(diff);

            if (point.canSendExistingPieceToBar(this)) {
              point.swapOpposingPieces(this);
            } else {
              point.acquirePiece(this);
            }

            isMoving = true;
          }
          break;
        case final WinPile winPile: // A Piece can only move to the win pile from a point

          final currentLocation = _location;
          if (currentLocation is Point) {
            final currentOrder = currentLocation.order;
            final diff = owner.isPlayer
                ? winPile.locationOrder(owner) - currentOrder
                : currentOrder - winPile.locationOrder(owner);

            if (gameState.canMoveDistance(diff, type: MovementType.atMost)) {
              gameNotifier.updateMovementStats(diff, type: MovementType.atMost);
              winPile.acquirePiece(this);
              isMoving = true;
            }
          }

          break;
      }
    }

    if (isMoving) {
      gameNotifier.maybeEndTurn(owner);
    } else {
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
