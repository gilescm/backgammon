import 'package:backgammon/components/component_enums.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

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

const dieSprites = <int, SpriteConfig>{
  1: SpriteConfig(SpriteAssetType.die, 8, 0, 16, 16),
  2: SpriteConfig(SpriteAssetType.die, 8 + 64, 16, 16, 16),
  3: SpriteConfig(SpriteAssetType.die, 8 + 64, 0, 16, 16),
  4: SpriteConfig(SpriteAssetType.die, 8 + 64 * 2, 16, 16, 16),
  5: SpriteConfig(SpriteAssetType.die, 8 + 64 * 3, 17, 16, 16),
  6: SpriteConfig(SpriteAssetType.die, 8 + 64 * 2, 0, 16, 16),
};

const Map<PieceColor, SpriteConfig> pieceSprites = {
  PieceColor.silver: SpriteConfig(SpriteAssetType.piece, 1, 18, 14, 16),
  PieceColor.white: SpriteConfig(SpriteAssetType.piece, 1, 66, 14, 16),
  PieceColor.red: SpriteConfig(SpriteAssetType.piece, 1, 114, 14, 16),
  PieceColor.green: SpriteConfig(SpriteAssetType.piece, 1, 162, 14, 16),
  PieceColor.yellow: SpriteConfig(SpriteAssetType.piece, 1, 210, 14, 16),
  PieceColor.emerald: SpriteConfig(SpriteAssetType.piece, 1, 258, 14, 16),
  PieceColor.purple: SpriteConfig(SpriteAssetType.piece, 1, 306, 14, 16),
  PieceColor.blue: SpriteConfig(SpriteAssetType.piece, 1, 354, 14, 16),
  PieceColor.orange: SpriteConfig(SpriteAssetType.piece, 1, 402, 14, 16),
};

@immutable
class SpriteConfig {
  const SpriteConfig(this.type, this.x, this.y, this.width, this.height);

  final SpriteAssetType type;
  final double x;
  final double y;
  final double width;
  final double height;
}
