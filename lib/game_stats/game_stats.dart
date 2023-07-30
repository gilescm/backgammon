import 'package:backgammon/game/backgammon_state.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:backgammon/utils/string_utils.dart';
import 'package:backgammon/utils/theme_utils.dart';
import 'package:backgammon/widgets/dialogs.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'game_stats.rules.dart';

class GameStatsSideBar extends ConsumerWidget {
  const GameStatsSideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(backgammonStateProvider);

    final currentPlayer = gameState.currentPlayer;
    final playerName = currentPlayer.name.capitalize();

    final dieValues = gameState.dieValues;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kSize8,
        vertical: kSize24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$playerName\'s turn'),
          context.vBox16,
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _BackgammonSprite(config: pieceSprites[currentPlayer.pieceColor]),
              context.hBox8,
              if (gameState.totalRolled == 0)
                Text(
                  'Tap the dice to roll...',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              else ...[
                for (final dieValue in dieValues) _BackgammonSprite(config: dieSprites[dieValue]),
              ]
            ],
          ),
          if (gameState.totalRolled != 0) ...[
            _GeneralRules(
              isPlayer: currentPlayer.isPlayer,
              isPieceInBar: gameState.doesCurrentPlayerHavePieceInBar,
            ),
            ElevatedButton(
              onPressed: () {
                final gameNotifier = ref.read(backgammonStateProvider.notifier);
                gameNotifier.endTurn();
              },
              child: const Text('End turn'),
            )
          ],
        ],
      ),
    );
  }
}

class _BackgammonSprite extends StatelessWidget {
  const _BackgammonSprite({required this.config});

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
