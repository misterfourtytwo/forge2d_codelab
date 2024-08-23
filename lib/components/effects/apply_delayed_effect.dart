import 'package:flame/effects.dart';

class ApplyDelayedEffect extends ComponentEffect {
  ApplyDelayedEffect({
    double delay = 0.0,
    void Function()? onComplete,
    super.key,
  }) : super(
          LinearEffectController(delay),
          onComplete: onComplete,
        );

  @override
  void apply(double progress) {
    // if (progress == 1) {
    //   onComplete?.call();
    // }
  }
}
