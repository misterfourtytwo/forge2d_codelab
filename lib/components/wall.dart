import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'body_component_with_user_data.dart';

const wallSize = 14.0;

class Wall extends BodyComponentWithUserData {
  Wall(Vector2 position, Sprite sprite)
      : super(
          renderBody: false,
          bodyDef: BodyDef()
            ..position = position
            ..type = BodyType.static,
          fixtureDefs: [
            FixtureDef(
              PolygonShape()..setAsBoxXY(wallSize * 0.5, wallSize * 0.5),
              friction: 0.2,
            ),
          ],
          children: [
            SpriteComponent(
              anchor: Anchor.center,
              sprite: sprite,
              size: Vector2.all(wallSize),
              position: Vector2(0, 0),
            ),
          ],
        );
}
