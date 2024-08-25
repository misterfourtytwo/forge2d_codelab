import 'package:flutter/material.dart';
import 'package:forge2d_game/services/audio/audio_controller.dart';

import 'audio_provider.dart';
import 'page/audio_controls_page.dart';

class AudioControlsApp extends StatelessWidget {
  const AudioControlsApp({
    super.key,
    required this.audio,
  });

  final AudioController audio;

  @override
  Widget build(BuildContext context) {
    return AudioProvider(
      audio: audio,
      child: MaterialApp(
        title: 'SoLoud Menu App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
        ),
        home: const AudioControlsPage(),
      ),
    );
  }
}
