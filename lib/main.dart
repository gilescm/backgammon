import 'package:backgammon/backgammon_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

void main() {
  final game = BackgammonGame();
  runApp(GameWidget(game: game));
}
