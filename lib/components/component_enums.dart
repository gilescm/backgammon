enum PieceOwner {
  player(-1),
  opponent(1);

  const PieceOwner(this.direction);

  final int direction;

  bool get isPlayer => this == player;

  PieceOwner get other => isPlayer ? opponent : player;
}

enum PieceColor { silver, white, red, green, yellow, emerald, purple, blue, orange }

enum QuadrantType {
  topLeft([(PieceOwner.player, 5), (null, 0), (null, 0), (null, 0), (PieceOwner.opponent, 3), (null, 0)]),
  topRight([(PieceOwner.opponent, 5), (null, 0), (null, 0), (null, 0), (null, 0), (PieceOwner.player, 2)]),
  bottomLeft([(PieceOwner.opponent, 5), (null, 0), (null, 0), (null, 0), (PieceOwner.player, 3), (null, 0)]),
  bottomRight([(PieceOwner.player, 5), (null, 0), (null, 0), (null, 0), (null, 0), (PieceOwner.opponent, 2)]);

  const QuadrantType(this.startingPositions);

  final List<(PieceOwner?, int)> startingPositions;

  bool get isTop => this == topLeft || this == topRight;

  bool isStartingQuadrantFor(PieceOwner owner) => owner.isPlayer ? this == topRight : this == bottomRight;
}
