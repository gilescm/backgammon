import 'package:backgammon/game/backgammon_state.dart';
import 'package:backgammon/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'secret_overlay.state.dart';

class SecretOverlay extends ConsumerWidget {
  const SecretOverlay({required this.child, super.key});

  final Widget child;

  void _onTapDown(BuildContext context, WidgetRef ref, TapDownDetails details) {
    final secretNotifier = ref.read(secretStateProvider.notifier);
    if (secretNotifier.canDiscover) {
      final screenSize = MediaQuery.sizeOf(context);
      final quarterScreenWidth = screenSize.width / 4;
      final quarterScreenHeight = screenSize.height / 4;

      final tapDownPosition = details.globalPosition;
      if (tapDownPosition.dx < quarterScreenWidth && tapDownPosition.dy < quarterScreenHeight) {
        secretNotifier.updateLeftTaps();
      } else if (tapDownPosition.dx > screenSize.width - quarterScreenWidth &&
          tapDownPosition.dy > screenSize.height - quarterScreenHeight) {
        secretNotifier.updateRightTaps();
      }

      if (secretNotifier.hasDiscoveredSecret()) {
        context.go(RouteNames.webview.goName);
        secretNotifier.maybeResetTaps();
      }
    } else {
      secretNotifier.maybeResetTaps();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTapDown: (details) => _onTapDown(context, ref, details),
      child: child,
    );
  }
}
