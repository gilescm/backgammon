enum Player {
  player(-1),
  opponent(1);

  const Player(this.direction);

  final int direction;

  bool get isPlayer => this == player;

  Player get other => isPlayer ? opponent : player;
}

enum PieceColor { silver, white, red, green, yellow, emerald, purple, blue, orange }

enum QuadrantType {
  topLeft([(Player.player, 5), (null, 0), (null, 0), (null, 0), (Player.opponent, 3), (null, 0)]),
  topRight([(Player.opponent, 5), (null, 0), (null, 0), (null, 0), (null, 0), (Player.player, 2)]),
  bottomLeft([(Player.opponent, 5), (null, 0), (null, 0), (null, 0), (Player.player, 3), (null, 0)]),
  bottomRight([(Player.player, 5), (null, 0), (null, 0), (null, 0), (null, 0), (Player.opponent, 2)]);

  const QuadrantType(this.startingPositions);

  final List<(Player?, int)> startingPositions;

  bool get isTop => this == topLeft || this == topRight;

  bool isStartingQuadrantFor(Player owner) => owner.isPlayer ? this == topRight : this == bottomRight;
}
