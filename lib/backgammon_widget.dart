import 'package:backgammon/backgammon_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backgammonGameProvider = StateNotifierProvider<BackgammonGameNotifier, BackgammonGame?>(
  (ref) => BackgammonGameNotifier(),
);

class BackgammonGameNotifier extends StateNotifier<BackgammonGame?> {
  BackgammonGameNotifier() : super(null);

  void set(BackgammonGame candidate) {
    state = candidate;
  }
}

class BackgammonWidget extends ConsumerStatefulWidget {
  const BackgammonWidget.initialiseWithGame({
    super.key,
    required this.uninitialisedGame,
  });

  final BackgammonGame Function(WidgetRef ref)? uninitialisedGame;

  @override
  ConsumerState<BackgammonWidget> createState() => _RiverpodGameWidgetState();
}

class _RiverpodGameWidgetState extends ConsumerState<BackgammonWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.uninitialisedGame is FlameGame Function(WidgetRef ref)) {
        ref.read(backgammonGameProvider.notifier).set(widget.uninitialisedGame!(ref));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(backgammonGameProvider);

    if (game is! Game) {
      return Container();
    }

    return GameWidget(
      game: game!,
      loadingBuilder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
