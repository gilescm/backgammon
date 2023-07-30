import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/backgammon_state.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
  });

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
            GameStats(),
          ],
        ),
      ),
    );
  }
}

class GameStats extends ConsumerWidget {
  const GameStats({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameRef = ref.watch(backgammonStateProvider);
    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              gameRef.currentTurn.name,
              textAlign: TextAlign.center,
            ),
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
