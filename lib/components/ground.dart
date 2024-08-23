import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d_game/components/body_component_with_user_data.dart';
import 'package:forge2d_game/data/xml_sprite_sheet.dart';

const groundHalfSize = 7.0;
const groundSize = groundHalfSize + groundHalfSize;

class Ground extends BodyComponentWithUserData {
  Ground(Vector2 position, Sprite sprite)
      : super(
          renderBody: true,
          bodyDef: BodyDef()
            ..position = position
            ..type = BodyType.static,
          fixtureDefs: [
            FixtureDef(
              PolygonShape()..setAsBoxXY(groundHalfSize, groundHalfSize),
              friction: 0.2,
            ),
          ],
          children: [
            SpriteComponent(
              anchor: Anchor.center,
              sprite: sprite,
              size: Vector2.all(groundSize + fullCut + fullCut),
              position: Vector2(0, 0),
            ),
          ],
        );
}
