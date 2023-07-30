import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/game_stats/game_stats.dart';
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    return MaterialApp(
      home: SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: Colors.blue,
          body: Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: screenWidth * .75),
                child: GameWidget(
                  game: BackgammonGame(ref),
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
    );
  }
}
