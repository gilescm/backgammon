import 'package:backgammon/game/backgammon_state.dart';
import 'package:backgammon/utils/sprite_utils.dart';
import 'package:backgammon/utils/theme_utils.dart';
import 'package:backgammon/widgets/backgammon_sprite_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameStatsQuickReference extends ConsumerWidget {
  const GameStatsQuickReference({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(backgammonStateProvider);
    final playerPieceColor = gameState.currentPlayer.pieceColor;
    final dieValues = gameState.dieValues;
    return Column(
      children: [
        const EndDrawerButton(),
        context.vBox8,
        BackgammonSpriteWidget(config: pieceSprites[playerPieceColor]),
        context.vBox8,
        for (final dieValue in dieValues) ...[
          BackgammonSpriteWidget(config: dieSprites[dieValue]),
        ]
      ],
    );
  }
}
