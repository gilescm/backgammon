import 'package:backgammon/components/component_enums.dart';
import 'package:backgammon/components/piece.dart';
import 'package:backgammon/components/piece_location/piece_location.dart';
import 'package:backgammon/components/quadrant.dart';
import 'package:backgammon/components/roll_button.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

class BackgammonGame extends FlameGame {
  static const double _gameUnit = 20.0;

  static const double _pointWidth = _gameUnit * 6;
  static const double _pointHeight = _pointWidth * 4;

  static final Vector2 buttonSize = Vector2(barSize.x / 2, barSize.x / 2);
  static final Vector2 pieceSize = Vector2(_pointWidth * (2 / 3), _pointWidth * (2 / 3));
  static final Vector2 pointSize = Vector2(_pointWidth, _pointHeight);
  static final Vector2 barSize = Vector2(pieceSize.x * 1.25, pointSize.y * 2);
  static final Vector2 quadrantSize = Vector2(_pointWidth * 6, _pointHeight);
  static final Vector2 boardSize = Vector2(_pointWidth * 12 + barSize.x * 2, _pointHeight * 2);

  static const int maxPiecesPerPoint = 5;
  static const int pointsPerQuadrant = 6;

  @override
  Future<void> onLoad() async {
    await Flame.device.setLandscape();

    for (final spriteAsset in SpriteAssetType.values) {
      await Flame.images.load(spriteAsset.path);
    }

    final world = World();

    final bar = Bar();
    final winPile = WinPile();
    world.add(bar);
    world.add(winPile);

    final quadrants = [
      Quadrant(type: QuadrantType.topLeft, position: Vector2(0, quadrantSize.y)),
      Quadrant(type: QuadrantType.bottomLeft, position: Vector2(0, quadrantSize.y * 2)),
      Quadrant(type: QuadrantType.topRight, position: Vector2(quadrantSize.x + barSize.x, quadrantSize.y)),
      Quadrant(
        type: QuadrantType.bottomRight,
        position: Vector2(quadrantSize.x + barSize.x, quadrantSize.y * 2),
      )
    ];

    // ignore: unawaited_futures
    world.addAll(quadrants);

    for (final quadrant in quadrants) {
      final points = <Point>[];

      for (var i = 0; i < pointsPerQuadrant; i++) {
        final point = Point(
          quadrantType: quadrant.type,
          order: quadrant.type.isTop ? pointsPerQuadrant - i - 1 : i,
          position: Vector2(quadrant.position.x + (quadrant.size.x / 6 * i), quadrant.position.y),
          size: Vector2(quadrant.size.x / 6, quadrant.size.y),
        );
        points.add(point);
        world.add(point);

        final (pieceOwner, numberOfPieces) = quadrant.type.startingPositions[i];
        if (pieceOwner != null) {
          for (var j = 0; j < numberOfPieces; j++) {
            final piece = Piece(
              owner: pieceOwner,
              color: pieceOwner.isPlayer ? PieceColor.silver : PieceColor.orange,
              location: point,
            );

            point.acquirePiece(piece);
            world.add(piece);
          }
        }
      }
    }

    world.add(Dice());
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = boardSize
      ..viewfinder.position = Vector2(boardSize.x / 2, boardSize.y / 2)
      ..viewfinder.anchor = Anchor.topCenter;
    add(camera);
  }
}
