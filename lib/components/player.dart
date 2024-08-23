import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d_game/common/common.dart';
import 'package:forge2d_game/components/body_component_with_user_data.dart';
import 'package:forge2d_game/components/painters/worms_painter.dart';

const playerRadius = 3.0;
const playerSize = playerRadius + playerRadius;

enum PlayerColor {
  pink,
  blue,
  green,
  yellow;

  static PlayerColor get randomColor =>
      PlayerColor.values[rand.nextInt(PlayerColor.values.length)];

  String get fileName =>
      'alien${toString().split('.').last.capitalize}_round.png';
}

class Player extends BodyComponentWithUserData
    with DragCallbacks
    implements DraggableRoundItem {
  Player(Vector2 position, Sprite sprite)
      : _sprite = sprite,
        super(
          priority: 5,
          renderBody: false,
          bodyDef: BodyDef()
            ..position = position
            ..type = BodyType.static
            ..angularDamping = 0.1
            ..linearDamping = 0.1,
          fixtureDefs: [
            FixtureDef(CircleShape(radius: playerRadius))
              ..restitution = 0.4
              ..density = 0.75
              ..friction = 0.5
          ],
        );
  @override
  double get radius => playerRadius;
  final Sprite _sprite;

  @override
  Future<void> onLoad() async {
    addAll([
      // CustomPainterComponent(
      //   painter: DragPainter(draggable: this),
      //   anchor: Anchor.center,
      //   size: Vector2(playerSize, playerSize),
      //   position: Vector2(0, 0),
      // ),
      SpriteComponent(
        anchor: Anchor.center,
        sprite: _sprite,
        size: Vector2(playerSize, playerSize),
        position: Vector2(0, 0),
      ),
      CustomPainterComponent(
        painter: WormsPainter(draggable: this),
        anchor: Anchor.center,
        priority: 5,
        size: Vector2(playerSize, playerSize),
        position: Vector2(0, 0),
      ),
    ]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // if (!body.isAwake) {
    //   removeFromParent();
    // }
    if (body.linearVelocity.length.abs() < 1) {
      body.setType(BodyType.static);
      body.linearVelocity.scaleTo(0);
      body.angularVelocity = 0;
      body.setSleepingAllowed(true);
    }

    if (!camera.visibleWorldRect.contains(position.toOffset())) {
      removeFromParent();
    }
  }

  Vector2 _dragStart = Vector2.zero();
  Vector2 _dragDelta = Vector2.zero();
  @override
  Vector2 get dragDelta => _dragDelta;

  bool get couldDrag => body.bodyType == BodyType.static || !body.isAwake;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (couldDrag) {
      _dragStart = event.localPosition;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (couldDrag) {
      _dragDelta = event.localEndPosition - _dragStart;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (couldDrag) {
      body.setType(BodyType.dynamic);
      body.applyLinearImpulse(_dragDelta * -50);
      _dragDelta = Vector2.zero();
      _dragStart = Vector2.zero();
    }
  }
}
