import 'package:backgammon/utils/sprite_utils.dart';
import 'package:backgammon/utils/theme_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

class BackgammonSpriteWidget extends StatelessWidget {
  const BackgammonSpriteWidget({required this.config, super.key});

  final SpriteConfig? config;

  @override
  Widget build(BuildContext context) {
    final spriteConfig = config;

    if (spriteConfig == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: kSize24,
      height: kSize24,
      child: SpriteWidget.asset(
        anchor: Anchor.center,
        path: spriteConfig.type.path,
        srcPosition: Vector2(spriteConfig.x, spriteConfig.y),
        srcSize: Vector2(spriteConfig.width, spriteConfig.height),
      ),
    );
  }
}
