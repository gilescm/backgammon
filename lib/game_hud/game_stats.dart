import 'package:backgammon/game/backgammon_state.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:backgammon/utils/string_utils.dart';
import 'package:backgammon/utils/theme_utils.dart';
import 'package:backgammon/widgets/backgammon_sprite_widget.dart';
import 'package:backgammon/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'game_stats.rules.dart';

class GameStatsAndRulesDrawer extends ConsumerWidget {
  const GameStatsAndRulesDrawer({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('$playerName\'s turn'),
                  context.vBox16,
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      BackgammonSpriteWidget(config: pieceSprites[currentPlayer.pieceColor]),
                      context.hBox8,
                      if (gameState.totalRolled == 0)
                        Text('Tap the dice to roll...', style: Theme.of(context).textTheme.bodySmall)
                      else ...[
                        for (final dieValue in dieValues) BackgammonSpriteWidget(config: dieSprites[dieValue]),
                      ]
                    ],
                  ),
                ],
              ),
              context.hBox8,
              ElevatedButton(
                onPressed: () {
                  final gameNotifier = ref.read(backgammonStateProvider.notifier);
                  gameNotifier.endTurn();
                },
                child: const Text('End turn'),
              )
            ],
          ),
          if (gameState.totalRolled != 0) ...[
            const Spacer(),
            _GeneralRules(
              isPlayer: currentPlayer.isPlayer,
              isPieceInBar: gameState.doesCurrentPlayerHavePieceInBar,
            ),
          ],
        ],
      ),
    );
  }
}
