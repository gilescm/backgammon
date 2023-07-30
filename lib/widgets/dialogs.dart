import 'package:backgammon/utils/theme_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

Future<void> showDialogWithSingleDismissAction({
  required BuildContext context,
  required String title,
  required String body,
}) async {
  assert(title.isNotEmpty);
  assert(body.isNotEmpty);

  await showPlatformDialog<void>(
    context: context,
    builder: (context) => BasicDialogAlert(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.only(top: kSize8),
        child: Text(body),
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: const Text('Got it!'),
          onPressed: Navigator.of(context).pop,
        ),
      ],
    ),
  );
}
