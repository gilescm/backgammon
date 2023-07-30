import 'dart:math' as math;
import 'dart:ui';

import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';

class Dice extends PositionComponent with TapCallbacks {
  Dice()
      : super(
          priority: 100,
          position: Vector2(
            BackgammonGame.quadrantSize.x,
            BackgammonGame.quadrantSize.y * 2 - BackgammonGame.buttonSize.y / 2,
          ),
          size: Vector2(BackgammonGame.buttonSize.x * 2, BackgammonGame.buttonSize.y),
        );

  @override
  void onLoad() {
    final firstDieButton = _Die();
    final secondDieButton = _Die(
      position: firstDieButton.position + Vector2(BackgammonGame.buttonSize.x, 0),
    );

    add(firstDieButton);
    add(secondDieButton);
  }

  @override
  void render(Canvas canvas) {
    for (final child in children) {
      child.render(canvas);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    for (final child in children) {
      if (child is _Die) {
        child.onTapDown(event);
      }
    }

    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    for (final child in children) {
      if (child is _Die) {
        child.onTapUp(event);
      }
    }

    super.onTapUp(event);
  }
}

/// Custom version of a "ButtonComponent" for use only in Dice
/// to help "animate" the two die's at the same time
class _Die extends PositionComponent with HasAncestor<Dice> {
  _Die({super.position}) : super(size: BackgammonGame.buttonSize) {
    _value = math.min(_rand.nextInt(6) + 1, 6);
    _initSprites();
  }

  late int _value;
  late SpriteGroupComponent<int> button;
  late SpriteAnimationComponent buttonDown;

  final _rand = math.Random();

  void onTapDown(TapDownEvent event) {
    button.removeFromParent();
    buttonDown.parent = this;
  }

  void onTapUp(TapUpEvent event) {
    buttonDown.removeFromParent();
    button.parent = this;
    _value = math.min(_rand.nextInt(6) + 1, 6);
    button.current = _value;
  }

  void _initSprites() {
    button = SpriteGroupComponent<int>(
      position: Vector2.zero(),
      size: BackgammonGame.buttonSize,
      current: _value,
      sprites: {
        1: backgammonSprite(
          SpriteAssetType.die,
          x: 8,
          y: 0,
          width: 16,
          height: 16,
        ),
        2: backgammonSprite(
          SpriteAssetType.die,
          x: 8 + 64,
          y: 16,
          width: 16,
          height: 16,
        ),
        3: backgammonSprite(
          SpriteAssetType.die,
          x: 8 + 64,
          y: 0,
          width: 16,
          height: 16,
        ),
        4: backgammonSprite(
          SpriteAssetType.die,
          x: 8 + 64 * 2,
          y: 16,
          width: 16,
          height: 16,
        ),
        5: backgammonSprite(
          SpriteAssetType.die,
          x: 8 + 64 * 3,
          y: 17,
          width: 16,
          height: 16,
        ),
        6: backgammonSprite(
          SpriteAssetType.die,
          x: 8 + 64 * 2,
          y: 0,
          width: 16,
          height: 16,
        ),
      },
    );

    buttonDown = SpriteAnimationComponent.fromFrameData(
      Flame.images.fromCache(SpriteAssetType.die.path),
      SpriteAnimationData.sequenced(
        textureSize: Vector2(32, 16),
        amount: 12,
        amountPerRow: 6,
        stepTime: 0.2,
      ),
      position: Vector2(-BackgammonGame.buttonSize.x / 2, 0),
      size: Vector2(BackgammonGame.buttonSize.x * 2, BackgammonGame.buttonSize.y),
    );

    add(button);
  }
}
