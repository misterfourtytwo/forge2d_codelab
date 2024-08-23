import 'package:characters/characters.dart';

extension Capitalize on String {
  String get capitalize =>
      characters.first.toUpperCase() + characters.skip(1).toLowerCase().join();
}
