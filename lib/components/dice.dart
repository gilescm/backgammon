import 'dart:math' as math;
import 'dart:ui';

import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/backgammon_state.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

class Dice extends PositionComponent with TapCallbacks, HasComponentRef {
  Dice()
      : super(
          position: Vector2(
            BackgammonGame.quadrantSize.x + BackgammonGame.dieSize.x * 0.15,
            BackgammonGame.quadrantSize.y * 2 - BackgammonGame.dieSize.y,
          ),
          size: Vector2(BackgammonGame.dieSize.x, BackgammonGame.dieSize.y * 2),
        );

  @override
  Future<void> onLoad() async {
    children.register<_Die>();

    final firstDieButton = _Die();
    final secondDieButton = _Die(
      position: firstDieButton.position + Vector2(0, BackgammonGame.dieSize.y),
    );

    add(firstDieButton);
    add(secondDieButton);
  }

  @override
  void render(Canvas canvas) {
    for (final child in children.query<_Die>()) {
      child.render(canvas);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    for (final child in children.query<_Die>()) {
      child.onTapDown(event);
    }

    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    for (final child in children.query<_Die>()) {
      child.onTapUp(event);
    }

    _saveValuesToGame();

    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    for (final child in children.query<_Die>()) {
      child.onTapCancel(event);
    }

    _saveValuesToGame();

    super.onTapCancel(event);
  }

  void _saveValuesToGame() {
    final gameState = ref.read(backgammonStateProvider);
    gameState.updateDieValues(
      children.query<_Die>().map((die) => die._value),
    );
  }
}

/// Custom version of a "ButtonComponent" for use only in the
/// `TwoDice` component to help "animate" the two die's.
class _Die extends PositionComponent with HasAncestor<Dice> {
  _Die({super.position}) : super(size: BackgammonGame.dieSize) {
    _initSprites();
  }

  late SpriteGroupComponent<int> _button;
  late SpriteAnimationComponent _buttonDown;

  int _value = 0;

  final _rand = math.Random();

  void onTapDown(TapDownEvent event) {
    _button.removeFromParent();
    _buttonDown.parent = this;
  }

  void onTapUp(TapUpEvent event) {
    _buttonDown.removeFromParent();
    _button.parent = this;
    _value = math.min(_rand.nextInt(6) + 1, 6);
    _button.current = _value;
  }

  void onTapCancel(TapCancelEvent event) {
    _buttonDown.removeFromParent();
    _button.parent = this;
  }

  void _initSprites() {
    _button = SpriteGroupComponent<int>(
      position: Vector2.zero(),
      size: BackgammonGame.dieSize,
      current: _value == 0 ? math.min(_rand.nextInt(6) + 1, 6) : _value,
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

    _buttonDown = SpriteAnimationComponent.fromFrameData(
      Flame.images.fromCache(SpriteAssetType.die.path),
      SpriteAnimationData.sequenced(
        textureSize: Vector2(32, 16),
        amount: 12,
        amountPerRow: 6,
        stepTime: 0.2,
      ),
      position: Vector2(-BackgammonGame.dieSize.x / 2, 0),
      size: Vector2(BackgammonGame.dieSize.x * 2, BackgammonGame.dieSize.y),
    );

    add(_button);
  }
}
