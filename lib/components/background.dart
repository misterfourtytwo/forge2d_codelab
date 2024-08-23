import 'dart:math';

import 'package:flame/components.dart';

import 'game.dart';

class Background extends SpriteComponent with HasGameReference<MyPhysicsGame> {
  Background({
    required super.sprite,
    required this.spriteSize,
  }) : super(
          anchor: Anchor.center,
          position: Vector2(0, 0),
        );

  final Vector2 spriteSize;
  double get ratio => spriteSize.y / spriteSize.x;

  @override
  void onMount() {
    super.onMount();

    size = Vector2(
      min(
        game.camera.visibleWorldRect.height,
        game.camera.visibleWorldRect.width * ratio,
      ),
      min(
        game.camera.visibleWorldRect.height / ratio,
        game.camera.visibleWorldRect.width,
      ),
    );
  }
}
