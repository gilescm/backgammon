import 'package:backgammon/game/backgammon_state.dart';
import 'package:backgammon/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final secretStateProvider = StateProvider<SecretState>((ref) {
  final gameState = ref.watch(backgammonStateProvider);
  final dieValues = List<int>.from(gameState.dieValues)..sort((a, b) => a - b);

  return SecretState(
    tapsOnLeft: dieValues[0],
    tapsOnRight: dieValues[1],
  );
});

class SecretState {
  SecretState({
    required this.tapsOnLeft,
    required this.tapsOnRight,
  });

  final int tapsOnLeft;
  final int tapsOnRight;

  bool get canDiscover => tapsOnLeft != 0 && tapsOnRight != 0;

  bool hasDiscoveredSecret(int leftTaps, int rightTaps) {
    return canDiscover && tapsOnLeft == leftTaps && tapsOnRight == rightTaps;
  }
}

class SecretOverlay extends ConsumerStatefulWidget {
  const SecretOverlay({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SecretOverlayState();
}

class SecretOverlayState extends ConsumerState<SecretOverlay> {
  int _totalLeftTaps = 0;
  int _totalRightTaps = 0;

  @override
  void initState() {
    super.initState();
  }

  void _resetTaps() {
    _totalLeftTaps = 0;
    _totalRightTaps = 0;
  }

  void _onTapDown(TapDownDetails details) {
    final secretState = ref.read(secretStateProvider);
    if (secretState.canDiscover) {
      final screenSize = MediaQuery.sizeOf(context);
      final quarterScreenWidth = screenSize.width / 4;
      final quarterScreenHeight = screenSize.height / 4;

      final tapDownPosition = details.globalPosition;
      if (tapDownPosition.dx < quarterScreenWidth && tapDownPosition.dy < quarterScreenHeight) {
        _totalLeftTaps++;
      } else if (tapDownPosition.dx > screenSize.width - quarterScreenWidth &&
          tapDownPosition.dy > screenSize.height - quarterScreenHeight) {
        _totalRightTaps++;
      }

      if (secretState.hasDiscoveredSecret(_totalLeftTaps, _totalRightTaps)) {
        context.go(RouteNames.webview.goName);
        _resetTaps();
      }
    } else {
      _resetTaps();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      child: widget.child,
    );
  }
}
