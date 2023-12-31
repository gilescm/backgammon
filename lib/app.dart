import 'package:backgammon/game/backgammon_game.dart';
import 'package:backgammon/game/backgammon_widget.dart';
import 'package:backgammon/game_hud/game_stats.dart';
import 'package:backgammon/game_hud/game_stats_quick_reference.dart';
import 'package:backgammon/widgets/secret_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackgammonApp extends StatefulWidget {
  const BackgammonApp({super.key});

  @override
  State<BackgammonApp> createState() => _BackgammonAppState();
}

class _BackgammonAppState extends State<BackgammonApp> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return SafeArea(
      top: true,
      child: SecretOverlay(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Scaffold(
              backgroundColor: Colors.cyan,
              endDrawer: const Drawer(child: GameStatsAndRulesDrawer()),
              body: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: screenWidth * .8),
                    child: const BackgammonWidget.controlled(
                      gameFactory: BackgammonGame.new,
                    ),
                  ),
                  const GameStatsQuickReference(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
