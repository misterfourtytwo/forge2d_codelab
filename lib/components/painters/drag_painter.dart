import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:forge2d_game/common/common.dart';

class DragPainter extends CustomPainter {
  const DragPainter({required this.draggable});

  final DraggableItem draggable;

  @override
  void paint(Canvas canvas, Size size) {
    if (draggable.dragDelta != Vector2.zero()) {
      var center = size.center(Offset.zero);
      canvas.drawLine(
        center,
        center + (draggable.dragDelta * -1).toOffset(),
        Paint()
          ..color = Colors.orange[800]!.withOpacity(0.7)
          ..strokeWidth = 0.4
          ..strokeCap = StrokeCap.square,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
