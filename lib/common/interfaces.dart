import 'package:flame/extensions.dart';

abstract interface class DraggableItem {
  Vector2 get dragDelta;
}

abstract interface class RoundItem {
  double get radius;
}

abstract interface class DraggableRoundItem
    implements DraggableItem, RoundItem {}
