import 'dart:developer' as dev;

// import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:forge2d_game/components/game.dart';
import 'package:forge2d_game/misc/audio_test_app/audio_controls_app.dart';
import 'package:forge2d_game/services/audio/audio_controller.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audio = await initSound();
  runApp(
    AudioControlsApp(
      audio: audio,
    ),
  );
  // runApp(
  //   const GameWidget.controlled(
  //     gameFactory: MyPhysicsGame.new,
  //   ),
  // );
}

Future<AudioController> initSound() async {
  // The `flutter_soloud` package logs everything
  // (from severe warnings to fine debug messages)
  // using the standard `package:logging`.
  // You can listen to the logs as shown below.
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });

  final audioController = AudioController();
  await audioController.initialize();
  return audioController;
}
