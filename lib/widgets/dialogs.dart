import 'package:backgammon/utils/theme_utils.dart';
import 'package:flutter/widgets.dart';
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
      title: title != null ? Text(title) : null,
      content: Padding(
        padding: EdgeInsets.only(top: kSize8),
        child: Text(body),
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: Text('Ok'),
          onPressed: Navigator.of(context).pop,
        ),
      ],
    ),
  );
}
