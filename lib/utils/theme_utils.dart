import 'package:flutter/widgets.dart';

const kSize8 = 8.0;
const kSize16 = 16.0;
const kSize24 = 24.0;
const kSize32 = 32.0;
const kSize48 = 48.0;
const kSize56 = 56.0;
const kSize64 = 64.0;

extension ThemeUtils on BuildContext {
  SizedBox get vBox8 => const SizedBox(height: kSize8);
  SizedBox get vBox16 => const SizedBox(height: kSize16);

  SizedBox get hBox8 => const SizedBox(width: kSize8);
  SizedBox get hBox16 => const SizedBox(width: kSize16);
}
