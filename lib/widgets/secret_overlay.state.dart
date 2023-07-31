part of 'secret_overlay.dart';

final secretStateProvider = StateNotifierProvider<SecretStateNotifier, SecretState>((ref) {
  final gameState = ref.watch(backgammonStateProvider);
  final dieValues = List<int>.from(gameState.dieValues)..sort((a, b) => a - b);

  return SecretStateNotifier(
    SecretState(
      tapsOnLeft: dieValues[0],
      tapsOnRight: dieValues[1],
    ),
  );
});

class SecretState {
  SecretState({required this.tapsOnLeft, required this.tapsOnRight});

  final int tapsOnLeft;
  final int tapsOnRight;

  bool get canDiscover => tapsOnLeft != 0 && tapsOnRight != 0;

  bool hasDiscoveredSecret(int leftTaps, int rightTaps) {
    return canDiscover && tapsOnLeft == leftTaps && tapsOnRight == rightTaps;
  }
}

class SecretStateNotifier extends StateNotifier<SecretState> {
  SecretStateNotifier(super.state);

  SecretState attempt = SecretState(tapsOnLeft: 0, tapsOnRight: 0);

  bool get canDiscover => state.tapsOnLeft != 0 && state.tapsOnRight != 0;

  bool hasDiscoveredSecret() {
    return canDiscover && attempt.tapsOnLeft == state.tapsOnLeft && attempt.tapsOnRight == state.tapsOnRight;
  }

  void updateLeftTaps() {
    attempt = SecretState(
      tapsOnLeft: attempt.tapsOnLeft + 1,
      tapsOnRight: attempt.tapsOnRight,
    );
  }

  void updateRightTaps() {
    attempt = SecretState(
      tapsOnLeft: attempt.tapsOnLeft,
      tapsOnRight: attempt.tapsOnRight + 1,
    );
  }

  void maybeResetTaps() {
    if (attempt.tapsOnLeft != 0 && attempt.tapsOnRight != 0) {
      attempt = SecretState(tapsOnLeft: 0, tapsOnRight: 0);
    }
  }
}
