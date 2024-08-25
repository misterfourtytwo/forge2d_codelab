part of 'buttons.dart';

class ToggleBgmButton extends StatelessWidget {
  const ToggleBgmButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioProvider.of(context)!.audio;

    return ValueListenableBuilder<bool>(
      valueListenable: audio.bgmPlaying,
      builder: (context, bgmPlaying, _) {
        return OutlinedButton(
          onPressed: audio.toggleBgm,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Text(
              '${bgmPlaying ? 'Pause' : 'Start'} '
              'Music',
            ),
          ),
        );
      },
    );
  }
}
