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
      var dragOffset = -draggable.dragDelta.toOffset();
      final initialDistance = dragOffset.distance;
      final maxOffset = dragOffset / initialDistance * 21.0;
      dragOffset =
          maxOffset.distance < dragOffset.distance ? maxOffset : dragOffset;

      final double r2 = r1 * math.log(dragOffset.distance + math.e);
      final painterOffsetDelta = draggable.radius + offset + r1;
      final painterOffset =
          dragOffset / dragOffset.distance * painterOffsetDelta;
      final p1 = size.center(Offset.zero) + painterOffset;
      final p2 = p1 + dragOffset;

      final p = getPainterPath(p1, r1, p2, r2);

      final path = Path();
      path.moveTo(p[0].dx, p[0].dy);
      path.arcToPoint(
        p[1],
        rotation: math.pi,
        radius: const Radius.circular(r1),
        clockwise: false,
      );
      path.lineTo(p[2].dx, p[2].dy);
      path.arcToPoint(
        p[3],
        radius: Radius.circular(r2),
        rotation: math.pi,
        clockwise: false,
      );
      path.close();

      final shader = ui.Gradient.linear(
        p1,
        p1 + maxOffset,
        [
          Colors.amber[300]!,
          Colors.amber[400]!,
          Colors.amber[600]!,
          Colors.amber[800]!,
          Colors.red,
          Colors.red[900]!,
        ],
        [
          0,
          1 / 5,
          2 / 5,
          3 / 5,
          4 / 5,
          5 / 5,
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
  static List<Offset> getPainterPath(
    Offset inputPoint1,
    double inputRadius1,
    Offset inputPoint2,
    double inputRadius2,
  ) {
    late final Offset p1, p2;
    late final double r1, r2;
    if (inputPoint1.dx <= inputPoint2.dx) {
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

    final sinAlpha = (p2.dy - p1.dy) / (p2 - p1).distance;
    final sinBeta = math.sqrt(1 - sqr(sinAlpha));

    final a1 = r1 * sinAlpha;
    final b1 = r1 * sinBeta;
    final a2 = r2 * sinAlpha;
    final b2 = r2 * sinBeta;

    return [
      if (p1 == inputPoint1) ...[
        Offset(p1.dx + a1, p1.dy - b1),
        Offset(p1.dx - a1, p1.dy + b1),
      ],
      Offset(p2.dx - a2, p2.dy + b2),
      Offset(p2.dx + a2, p2.dy - b2),
      // move order to match input, so we always start path around p1
      if (p1 != inputPoint1) ...[
        Offset(p1.dx + a1, p1.dy - b1),
        Offset(p1.dx - a1, p1.dy + b1),
      ]
    ];
  }
}
