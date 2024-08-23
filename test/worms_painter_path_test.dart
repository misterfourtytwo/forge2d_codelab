import 'dart:math';

import 'package:flame/components.dart';
import 'package:forge2d_game/components/painters/worms_painter.dart';
import 'package:test/test.dart';

/// Hereonafter:
/// p1 is (x1, y1),
/// r1 is radius around p1,
/// p2 is (x2, y1),
/// r2 is radius around p2,
/// alpha is an angle between Ox and line p1->p2
/// beta is an angle between line p2->p1 and Oy
class _WormsPainterTestCase {
  const _WormsPainterTestCase(
    this.title,
    this.p2,
    this.expectedPath,
  );

  final Vector2 p2;
  final List<Vector2> expectedPath;
  final String title;

  Vector2 get p1 => Vector2(0, 0);
  double get r1 => 1;
  double get r2 => 2;
}

final _testCases = [
  _WormsPainterTestCase(
    '0˚ == alpha',
    Vector2(5, 0),
    [
      Vector2(0, -1),
      Vector2(0, 1),
      Vector2(5, 2),
      Vector2(5, -2),
    ],
  ),
  _WormsPainterTestCase(
    '0˚ < alpha < 90˚',
    Vector2(3, 4),
    [
      Vector2(0.8, -0.6),
      Vector2(-0.8, 0.6),
      Vector2(1.4, 5.2),
      Vector2(4.6, 2.8),
    ],
  ),
  _WormsPainterTestCase(
    '90˚ == alpha',
    Vector2(0, 5),
    [
      Vector2(1, 0),
      Vector2(-1, 0),
      Vector2(-2, 5),
      Vector2(2, 5),
    ],
  ),
  _WormsPainterTestCase(
    '90˚ < alpha < 180˚',
    Vector2(-3, 4),
    [
      Vector2(0.8, 0.6),
      Vector2(-0.8, -0.6),
      Vector2(-4.6, 2.8),
      Vector2(-1.4, 5.2),
    ],
  ),
  _WormsPainterTestCase(
    'alpha == 180˚',
    Vector2(-5, 0),
    [
      Vector2(0, 1),
      Vector2(0, -1),
      Vector2(-5, -2),
      Vector2(-5, 2),
    ],
  ),
  _WormsPainterTestCase(
    '180˚ < alpha < 270˚',
    Vector2(-3, -4),
    [
      Vector2(-0.8, 0.6),
      Vector2(0.8, -0.6),
      Vector2(-1.4, -5.2),
      Vector2(-4.6, -2.8),
    ],
  ),
  _WormsPainterTestCase(
    'alpha == 270˚',
    Vector2(0, -5),
    [
      Vector2(-1, 0),
      Vector2(1, 0),
      Vector2(2, -5),
      Vector2(-2, -5),
    ],
  ),
  _WormsPainterTestCase(
    '270˚ < alpha < 360˚',
    Vector2(3, -4),
    [
      Vector2(-0.8, -0.6),
      Vector2(0.8, 0.6),
      Vector2(4.6, -2.8),
      Vector2(1.4, -5.2),
    ],
  ),
];

void main() {
  group(
    'test_paths_where',
    () {
      for (final testCase in _testCases) {
        test(testCase.title, () {
          final path = WormsPainter.getPainterPath(
            testCase.p1,
            testCase.r1,
            testCase.p2,
            testCase.r2,
          );
          expect(
            _checkEquality(testCase.expectedPath, path),
            true,
            reason: 'got\n${path.toString()}\n,'
                'when expected values are\n'
                '${testCase.expectedPath.toString()}',
          );
        });
      }
    },
  );
}

bool _checkEquality(List<Vector2> a, List<Vector2> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    final p = a[i];
    final t = b[i];
    if (1e-5 <
        max(
          (p.x - t.x).abs(),
          (p.y - t.y).abs(),
        )) return false;
  }
  return true;
}
