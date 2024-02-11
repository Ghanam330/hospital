// Place fonts/icons.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: Iconly-Broken
//      fonts:
//       - asset: fonts/icons.ttf
import 'package:flutter/widgets.dart';

class IconBroken {
  IconBroken._();

  static const String _fontFamily = 'IconBroken';
  static const IconData User = IconData(0xe900, fontFamily: _fontFamily);
  static const IconData Call = IconData(0xe91f, fontFamily: _fontFamily);
  static const IconData Camera = IconData(0xe921, fontFamily: _fontFamily);
  static const IconData Danger = IconData(0xe926, fontFamily: _fontFamily);
}
