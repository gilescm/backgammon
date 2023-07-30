part of 'game_stats.dart';

class _GeneralRules extends StatelessWidget {
  const _GeneralRules({
    required this.isPlayer,
    required this.isPieceInBar,
  });

  final bool isPlayer;
  final bool isPieceInBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isPieceInBar)
          ListTile(
            dense: true,
            title: const Text('The Bar'),
            onTap: () {
              showDialogWithSingleDismissAction(
                context: context,
                title: 'The Bar',
                body: 'You can only move the pieces in the bar, until there are no pieces left. You must move the'
                    ' pieces into the ${isPlayer ? 'top' : 'bottom'} right of the board. You can move one piece per'
                    ' die.',
              );
            },
          )
        else ...[
          ListTile(
            dense: true,
            title: const Text('Movement'),
            onTap: () {
              showDialogWithSingleDismissAction(
                context: context,
                title: 'Movement',
                body: 'You can move up to two pieces the value of one die each, or you can move'
                    ' one piece the total value of both dice.',
              );
            },
          ),
          ListTile(
            dense: true,
            title: const Text('Movement direction'),
            onTap: () {
              showDialogWithSingleDismissAction(
                context: context,
                title: 'Movement direction',
                body: 'Move ${isPlayer ? 'anti-clockwise' : 'clockwise'} around the board between points'
                    ' (the white and red areas). You can only move to "open" points. An "open" point is one that has '
                    'no more than 2 opposing pieces',
              );
            },
          ),
          ListTile(
            dense: true,
            title: const Text('Capturing'),
            onTap: () {
              showDialogWithSingleDismissAction(
                context: context,
                title: 'Capturing',
                body: 'If you move to a point that has 1 opponent piece, then that piece is sent to the bar (middle'
                    ' area) and they have to spend their turn bringing the piece out and into their starting area.',
              );
            },
          ),
          ListTile(
            dense: true,
            title: const Text('Winning'),
            onTap: () {
              showDialogWithSingleDismissAction(
                context: context,
                title: 'Winning',
                body: 'When you reach the ${isPlayer ? 'bottom' : 'top'} right you can move pieces into the win pile'
                    ' (the blue area). Once all pieces are in the win pile you win!',
              );
            },
          ),
        ]
      ],
    );
  }
}
