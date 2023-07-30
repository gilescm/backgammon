import 'package:backgammon/backgammon_game.dart';
import 'package:backgammon/backgammon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text('Stats!'),
                ],
              ),
              Expanded(
                child: BackgammonWidget.initialiseWithGame(
                  uninitialisedGame: BackgammonGame.new,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
