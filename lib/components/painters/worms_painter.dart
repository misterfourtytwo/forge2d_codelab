import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:forge2d_game/common/common.dart';

const double r1 = 1;
const double offset = 1;

class WormsPainter extends CustomPainter {
  const WormsPainter({required this.draggable});

  final DraggableRoundItem draggable;

  @override
  void paint(Canvas canvas, Size size) {
    if (draggable.dragDelta != Vector2.zero()) {
      final double r2 = r1 * math.log(draggable.dragDelta.length + math.e);
      final painterOffsetDelta = draggable.radius + offset + r1;
      final painterOffset = -draggable.dragDelta /
          draggable.dragDelta.length *
          painterOffsetDelta;
      final p1 = size.center(Offset.zero).toVector2() + painterOffset;
      final p2 = p1 + (draggable.dragDelta * -1);

      final p = getPainterPath(p1, r1, p2, r2);

      final path = Path();
      path.moveTo(p[0].x, p[0].y);
      path.arcToPoint(
        p[1].toOffset(),
        rotation: math.pi,
        radius: const Radius.circular(r1),
        clockwise: false,
      );
      path.lineTo(p[2].x, p[2].y);
      path.arcToPoint(
        p[3].toOffset(),
        radius: Radius.circular(r2),
        rotation: math.pi,
        clockwise: false,
      );
      path.close();
      final shader = ui.Gradient.linear(
        p1.toOffset(),
        p2.toOffset(),
        [
          Colors.amber[300]!,
          Colors.red[900]!,
        ],
      );
      final paint = Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill
        ..shader = shader;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  /// Четыре точки пересечения касательных и радиуса окружностей
  static List<Vector2> getPainterPath(
    Vector2 inputPoint1,
    double inputRadius1,
    Vector2 inputPoint2,
    double inputRadius2,
  ) {
    late final Vector2 p1, p2;
    late final double r1, r2;
    if (inputPoint1.x <= inputPoint2.x) {
      p1 = inputPoint1;
      r1 = inputRadius1;
      p2 = inputPoint2;
      r2 = inputRadius2;
    } else {
      p1 = inputPoint2;
      r1 = inputRadius2;
      p2 = inputPoint1;
      r2 = inputRadius1;
    }

    final sinAlpha =
        (p2.y - p1.y) / math.sqrt(sqr(p2.x - p1.x) + sqr(p1.y - p2.y));
    final sinBeta = math.sqrt(1 - sqr(sinAlpha));

    final a1 = r1 * sinAlpha;
    final b1 = r1 * sinBeta;
    final a2 = r2 * sinAlpha;
    final b2 = r2 * sinBeta;

    final res = [
      if (p1 == inputPoint1) ...[
        Vector2(p1.x + a1, p1.y - b1),
        Vector2(p1.x - a1, p1.y + b1),
      ],
      Vector2(p2.x - a2, p2.y + b2),
      Vector2(p2.x + a2, p2.y - b2),
      // move order to match input, so we always start path around p1
      if (p1 != inputPoint1) ...[
        Vector2(p1.x + a1, p1.y - b1),
        Vector2(p1.x - a1, p1.y + b1),
      ]
    ];

    return (inputPoint1 == p1 ? res : res).toList();
  }
}
