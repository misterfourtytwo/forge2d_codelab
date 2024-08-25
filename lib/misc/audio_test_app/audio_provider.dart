import 'package:flutter/widgets.dart';
import 'package:forge2d_game/services/audio/audio_controller.dart';

class AudioProvider extends InheritedWidget {
  const AudioProvider({
    super.key,
    required super.child,
    required this.audio,
  });

  final AudioController audio;

  @override
  bool updateShouldNotify(covariant AudioProvider oldWidget) =>
      oldWidget.audio != audio;

  static AudioProvider? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AudioProvider>();
    assert(result != null, 'No AudioProvider found in context');

    return result!;
  }
}
