import 'package:backgammon/game/backgammon_game.dart';
import 'package:backgammon/game/backgammon_state.dart';
import 'package:backgammon/game/components/component_enums.dart';
import 'package:backgammon/game/components/piece.dart';
import 'package:backgammon/game/components/quadrant.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';

part 'bar.dart';
part 'point.dart';
part 'win_pile.dart';

sealed class PieceLocation extends PositionComponent {
  PieceLocation({super.position, super.size});

  void acquirePiece(Piece piece);

  void removePiece(Piece piece);

  void returnPiece(Piece piece);

  int locationOrder(Player owner) {
    switch (this) {
      case WinPile _:
        if (owner.isPlayer) {
          return BackgammonGame.numberOfQuadrants * BackgammonGame.pointsPerQuadrant;
        }

        return -1;
      case Bar _:
        if (owner.isPlayer) {
          return -1;
        }

        return BackgammonGame.numberOfQuadrants * BackgammonGame.pointsPerQuadrant;
      case final Point point:
        return point.order;
    }
  }
}
