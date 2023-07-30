import 'package:backgammon/game/backgammon_game.dart';
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
    required this.gameFactory,
  });

  final BackgammonGame Function(WidgetRef ref)? gameFactory;

  @override
  ConsumerState<BackgammonWidget> createState() => _BackgammonGameWidgetState();
}

class _BackgammonGameWidgetState extends ConsumerState<BackgammonWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.gameFactory is FlameGame Function(WidgetRef ref)) {
        ref.read(backgammonGameProvider.notifier).set(widget.gameFactory!(ref));
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
