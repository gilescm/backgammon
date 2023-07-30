import 'package:backgammon/game/backgammon_game.dart';
import 'package:backgammon/game/backgammon_widget.dart';
import 'package:backgammon/game_stats/game_stats.dart';
import 'package:backgammon/widgets/secret_overlay.dart';
import 'package:flutter/material.dart';

class BackgammonApp extends StatelessWidget {
  const BackgammonApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return SafeArea(
      top: true,
      child: SecretOverlay(
        child: Scaffold(
          backgroundColor: Colors.cyan,
          body: Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: screenWidth * .75),
                child: const BackgammonWidget.controlled(
                  gameFactory: BackgammonGame.new,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: screenWidth * .25),
                child: const GameStatsSideBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
