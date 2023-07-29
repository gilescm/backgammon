import 'package:flame/components.dart';
import 'package:flame/flame.dart';

enum SpriteAssetType {
  board('backgammon_board.png'),
  piece('backgammon_pieces.png'),
  die('backgammon_die.png');

  const SpriteAssetType(this.path);

  final String path;
}

Sprite backgammonSprite(
  SpriteAssetType assetName, {
  required double x,
  required double y,
  required double width,
  required double height,
}) {
  return Sprite(
    Flame.images.fromCache(assetName.path),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
