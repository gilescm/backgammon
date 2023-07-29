import 'package:backgammon/components/piece.dart';
import 'package:backgammon/components/quadrant.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'components/point.dart';

class BackgammonGame extends FlameGame {
  static const double _gameUnit = 800.0;

  static const double _pointWidth = _gameUnit * 6;
  static const double _pointHeight = _pointWidth * 4;

  static final Vector2 pieceSize = Vector2(_pointWidth * (2 / 3), _pointWidth * (2 / 3));
  static final Vector2 pointSize = Vector2(_pointWidth, _pointHeight);
  static final Vector2 quadrantSize = Vector2(_pointWidth * 6, _pointHeight);
  static final Vector2 boardSize = Vector2(_pointWidth * 12, _pointHeight * 2);

  @override
  Future<void> onLoad() async {
    for (final spriteAsset in SpriteAssetType.values) {
      await Flame.images.load(spriteAsset.path);
    }

    final world = World();

    final quadrants = [
      Quadrant(type: QuadrantType.topLeft, position: Vector2(0, quadrantSize.y)),
      Quadrant(type: QuadrantType.bottomLeft, position: Vector2(0, quadrantSize.y * 2)),
      Quadrant(type: QuadrantType.topRight, position: Vector2(quadrantSize.x, quadrantSize.y)),
      Quadrant(
        type: QuadrantType.bottomRight,
        position: Vector2(quadrantSize.x, quadrantSize.y * 2),
      )
    ];

    await world.addAll(quadrants);

    for (final quadrant in quadrants) {
      for (var i = 0; i < 6; i++) {
        final point = Point(
          order: i,
          position: Vector2(quadrant.position.x + (quadrant.size.x / 6 * i), quadrant.position.y),
        );
        point.size = Vector2(quadrant.size.x / 6, quadrant.size.y);
        world.add(point);
      }
    }

    for (var i = 0; i < 1; i++) {
      final piece = Piece(
        owner: PieceOwner.player,
        color: PieceColor.silver,
        position: Vector2(boardSize.x * 0.75, boardSize.y),
      );

      world.add(piece);
    }

    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = boardSize
      ..viewfinder.position = Vector2(boardSize.x / 2, boardSize.y / 2)
      ..viewfinder.anchor = Anchor.topCenter;
    add(camera);
  }
}
