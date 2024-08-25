part of 'buttons.dart';

class StopBgmButton extends StatelessWidget {
  const StopBgmButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioProvider.of(context)!.audio;

    return ValueListenableBuilder<bool>(
      valueListenable: audio.bgmPlaying,
      builder: (context, bgmPlaying, _) => OutlinedButton(
        onPressed: bgmPlaying ? audio.stopBgm : null,
        child: const AnimatedSize(
          duration: Duration(milliseconds: 300),
          child: Text('Stop Music'),
        ),
      ),
    );
  }
}
