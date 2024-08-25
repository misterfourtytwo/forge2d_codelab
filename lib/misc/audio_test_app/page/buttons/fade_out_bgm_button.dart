part of 'buttons.dart';

class FadeOutBgmButton extends StatelessWidget {
  const FadeOutBgmButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioProvider.of(context)!.audio;

    return ValueListenableBuilder<bool>(
      valueListenable: audio.bgmPlaying,
      builder: (context, bgmPlaying, _) => OutlinedButton(
        onPressed: bgmPlaying ? audio.fadeOutBgm : null,
        child: const AnimatedSize(
          duration: Duration(milliseconds: 300),
          child: Text('Fade Out Music'),
        ),
      ),
    );
  }
}
