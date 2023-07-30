import 'package:backgammon/game/backgammon_game.dart';
import 'package:backgammon/game/backgammon_widget.dart';
import 'package:backgammon/game_stats/game_stats.dart';
import 'package:backgammon/widgets/secret_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: BackgammonApp()),
  );
}

class BackgammonApp extends ConsumerWidget {
  const BackgammonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return MaterialApp(
      home: SafeArea(
        top: true,
        child: SecretOverlay(
          child: Scaffold(
            backgroundColor: Colors.cyan,
            body: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth * .75),
                  child: const BackgammonWidget.initialiseWithGame(
                    gameFactory: BackgammonGame.new,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth * .25),
                  child: const GameStats(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
