import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d_game/common/common.dart';
import 'package:forge2d_game/data/xml_sprite_sheet.dart';

import 'body_component_with_user_data.dart';

const enemyHalfSize = 3.0;
const enemySize = enemyHalfSize + enemyHalfSize;

enum EnemyColor {
  pink(color: 'pink', boss: false),
  blue(color: 'blue', boss: false),
  green(color: 'green', boss: false),
  yellow(color: 'yellow', boss: false),
  pinkBoss(color: 'pink', boss: true),
  blueBoss(color: 'blue', boss: true),
  greenBoss(color: 'green', boss: true),
  yellowBoss(color: 'yellow', boss: true);

  final bool boss;
  final String color;

  const EnemyColor({required this.color, required this.boss});

  static EnemyColor random() => values[rand.nextInt(values.length)];

  String get fileName =>
      'alien${color.capitalize}_${boss ? 'suit' : 'square'}.png';
}

class Enemy extends BodyComponentWithUserData with ContactCallbacks {
  Enemy(Vector2 position, Sprite sprite)
      : super(
          renderBody: false,
          bodyDef: BodyDef()
            ..position = position
            ..type = BodyType.dynamic,
          fixtureDefs: [
            FixtureDef(
              PolygonShape()..setAsBoxXY(enemyHalfSize, enemyHalfSize),
              friction: 0.3,
            )
          ],
          children: [
            SpriteComponent(
              anchor: Anchor.center,
              sprite: sprite,
              size: Vector2.all(enemySize + fullCut),
              position: Vector2(0, 0),
            ),
          ],
        );

  @override
  void beginContact(Object other, Contact contact) {
    var interceptVelocity =
        (contact.bodyA.linearVelocity - contact.bodyB.linearVelocity)
            .length
            .abs();
    if (interceptVelocity > 35) {
      removeFromParent();
    }

    super.beginContact(other, contact);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!camera.visibleWorldRect.contains(position.toOffset())) {
      removeFromParent();
    }
  }
}
