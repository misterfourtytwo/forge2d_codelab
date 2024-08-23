import 'dart:math';
import 'dart:ui';

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

  final Offset p2;
  final List<Offset> expectedPath;
  final String title;

  Offset get p1 => const Offset(0, 0);
  double get r1 => 1;
  double get r2 => 2;
}

const _testCases = [
  _WormsPainterTestCase(
    '0˚ == alpha',
    Offset(5, 0),
    [
      Offset(0, -1),
      Offset(0, 1),
      Offset(5, 2),
      Offset(5, -2),
    ],
  ),
  _WormsPainterTestCase(
    '0˚ < alpha < 90˚',
    Offset(3, 4),
    [
      Offset(0.8, -0.6),
      Offset(-0.8, 0.6),
      Offset(1.4, 5.2),
      Offset(4.6, 2.8),
    ],
  ),
  _WormsPainterTestCase(
    '90˚ == alpha',
    Offset(0, 5),
    [
      Offset(1, 0),
      Offset(-1, 0),
      Offset(-2, 5),
      Offset(2, 5),
    ],
  ),
  _WormsPainterTestCase(
    '90˚ < alpha < 180˚',
    Offset(-3, 4),
    [
      Offset(0.8, 0.6),
      Offset(-0.8, -0.6),
      Offset(-4.6, 2.8),
      Offset(-1.4, 5.2),
    ],
  ),
  _WormsPainterTestCase(
    'alpha == 180˚',
    Offset(-5, 0),
    [
      Offset(0, 1),
      Offset(0, -1),
      Offset(-5, -2),
      Offset(-5, 2),
    ],
  ),
  _WormsPainterTestCase(
    '180˚ < alpha < 270˚',
    Offset(-3, -4),
    [
      Offset(-0.8, 0.6),
      Offset(0.8, -0.6),
      Offset(-1.4, -5.2),
      Offset(-4.6, -2.8),
    ],
  ),
  _WormsPainterTestCase(
    'alpha == 270˚',
    Offset(0, -5),
    [
      Offset(-1, 0),
      Offset(1, 0),
      Offset(2, -5),
      Offset(-2, -5),
    ],
  ),
  _WormsPainterTestCase(
    '270˚ < alpha < 360˚',
    Offset(3, -4),
    [
      Offset(-0.8, -0.6),
      Offset(0.8, 0.6),
      Offset(4.6, -2.8),
      Offset(1.4, -5.2),
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

bool _checkEquality(List<Offset> a, List<Offset> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    final p = a[i];
    final t = b[i];
    if (1e-5 <
        max(
          (p.dx - t.dx).abs(),
          (p.dy - t.dy).abs(),
        )) return false;
  }
  return true;
}
