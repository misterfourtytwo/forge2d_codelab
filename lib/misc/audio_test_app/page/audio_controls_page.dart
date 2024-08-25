import 'package:flutter/material.dart';
import 'package:forge2d_game/common/common.dart';

import '../audio_provider.dart';
import 'buttons/buttons.dart';

class AudioControlsPage extends StatefulWidget {
  const AudioControlsPage({super.key});

  @override
  State<AudioControlsPage> createState() => _AudioControlsPageState();
}

class _AudioControlsPageState extends State<AudioControlsPage> {
  static const _gap = SizedBox(height: 16);

  bool filterApplied = false;

  @override
  Widget build(BuildContext context) {
    final audio = AudioProvider.of(context)?.audio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SoLoud Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                final pewNum = rand.nextInt(3) + 1;
                audio?.playSfx('pew$pewNum');
              },
              child: const Text('Play SFX'),
            ),
            _gap,
            const ToggleBgmButton(),
            _gap,
            const StopBgmButton(),
            _gap,
            const FadeOutBgmButton(),
            _gap,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Apply filter'),
                Checkbox(
                  value: filterApplied,
                  onChanged: (value) {
                    setState(() {
                      filterApplied = value!;
                    });
                    if (filterApplied) {
                      audio?.applyFilter();
                    } else {
                      audio?.removeFilter();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
