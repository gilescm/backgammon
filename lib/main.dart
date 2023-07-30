import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/game_stats.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.sizeOf(context);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenSize.width * .85),
              child: GameWidget(
                game: BackgammonGame(ref),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenSize.width * .15),
              child: const GameStats(),
            ),
          ],
        ),
      ),
    );
  }
}
