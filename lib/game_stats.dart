import 'package:backgammon/backgammon_state.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:backgammon/utils/string_utils.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameStats extends ConsumerWidget {
  const GameStats({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(backgammonStateProvider);

    final playerName = gameState.currentTurn.name.capitalize();

    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$playerName\'s turn',
              textAlign: TextAlign.center,
            ),
            if (gameState.totalRolled != 0)
              const SizedBox.shrink()
            else
              for (final dieValue in gameState.dieValues)
                SpriteWidget.asset(
                  anchor: Anchor.center,
                  path: SpriteAssetType.die.path,
                )

            // ListTile(
            //   title: const Text('Current Turn'),
            //   trailing: Text(gameRef.currentTurn.name),
            // ),
          ],
        ),
      ),
    );
  }
}
