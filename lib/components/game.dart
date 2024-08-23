import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' show Colors, TextStyle;
import 'package:forge2d_game/common/common.dart';
import 'package:forge2d_game/components/ground.dart';
import 'package:forge2d_game/data/xml_sprite_sheet.dart';

// import 'package:forge2d_game/data/xml_sprite_sheet.dart';

import 'background.dart';
import 'brick.dart';
import 'enemy.dart';
import 'player.dart';
import 'wall.dart';

const backgroundSpritePath = 'colored_land.png';
final Vector2 backgroundSpriteSize = Vector2(1024, 1024);

class MyPhysicsGame extends Forge2DGame {
  MyPhysicsGame()
      : super(
          gravity: Vector2(0, 9.81),
          camera: CameraComponent.withFixedResolution(
            width: backgroundSpriteSize.x,
            height: backgroundSpriteSize.y,
          ),
        );

  final AssetsCache _assetsCache = AssetsCache();
  final Images _imageCache = Images();
  late final XmlSpriteSheet aliens;
  late final XmlSpriteSheet debris;
  late final XmlSpriteSheet elements;
  late final XmlSpriteSheet explosive;
  late final XmlSpriteSheet glass;
  late final XmlSpriteSheet metal;
  late final XmlSpriteSheet stone;
  late final XmlSpriteSheet tiles;
  late final XmlSpriteSheet wood;

  /// Flame resources paths by default go to assets/images.
  /// [Doc](https://docs.flame-engine.org/latest/flame/rendering/images.html)
  @override
  FutureOr<void> onLoad() async {
    final backgroundSprite = await images.load(backgroundSpritePath);
    final spriteSheets = await [
      XmlSpriteSheet.load(
        imagePath: 'spritesheet_aliens.png',
        xmlPath: 'tiles/spritesheet_aliens.xml',
        imageCache: _imageCache,
        assetsCache: _assetsCache,
      ),
      XmlSpriteSheet.load(
        imagePath: 'spritesheet_debris.png',
        xmlPath: 'tiles/spritesheet_debris.xml',
        imageCache: _imageCache,
        assetsCache: _assetsCache,
      ),
      XmlSpriteSheet.load(
        imagePath: 'spritesheet_elements.png',
        xmlPath: 'tiles/spritesheet_elements.xml',
        imageCache: _imageCache,
        assetsCache: _assetsCache,
      ),
      XmlSpriteSheet.load(
        imagePath: 'spritesheet_explosive.png',
        xmlPath: 'tiles/spritesheet_explosive.xml',
        imageCache: _imageCache,
        assetsCache: _assetsCache,
      ),
      XmlSpriteSheet.load(
        imagePath: 'spritesheet_glass.png',
        xmlPath: 'tiles/spritesheet_glass.xml',
        imageCache: _imageCache,
        assetsCache: _assetsCache,
      ),
      XmlSpriteSheet.load(
        imagePath: 'spritesheet_metal.png',
        xmlPath: 'tiles/spritesheet_metal.xml',
        imageCache: _imageCache,
        assetsCache: _assetsCache,
      ),
      XmlSpriteSheet.load(
        imagePath: 'spritesheet_stone.png',
        xmlPath: 'tiles/spritesheet_stone.xml',
        imageCache: _imageCache,
        assetsCache: _assetsCache,
      ),
      XmlSpriteSheet.load(
        imagePath: 'spritesheet_tiles.png',
        xmlPath: 'tiles/spritesheet_tiles.xml',
        imageCache: _imageCache,
        assetsCache: _assetsCache,
      ),
      XmlSpriteSheet.load(
        imagePath: 'spritesheet_wood.png',
        xmlPath: 'tiles/spritesheet_wood.xml',
        imageCache: _imageCache,
        assetsCache: _assetsCache,
      ),
    ].wait;

    aliens = spriteSheets[0];
    debris = spriteSheets[1];
    elements = spriteSheets[2];
    explosive = spriteSheets[3];
    glass = spriteSheets[4];
    metal = spriteSheets[5];
    stone = spriteSheets[6];
    tiles = spriteSheets[7];
    wood = spriteSheets[8];

    await addBackground(backgroundSprite);
    await addWalls();
    await addGround();

    unawaited(addBricks().then((_) => addEnemies()));
    await addPlayer();
    return super.onLoad();
  }

  Future<void> addBackground(final Image backgroundSprite) async {
    return world.add(
      Background(
        sprite: Sprite(backgroundSprite),
        spriteSize: backgroundSpriteSize,
      ),
    );
  }

  Future<void> addGround() {
    return world.addAll([
      for (var x = camera.visibleWorldRect.left;
          x < camera.visibleWorldRect.right + groundSize;
          x += groundSize - cutWidth)
        Ground(
          Vector2(
            x,
            camera.visibleWorldRect.bottom - groundHalfSize,
          ),
          tiles.getSprite('grass.png'),
        ),
    ]);
  }

  Future<void> addWalls() {
    final leftBorderX = camera.visibleWorldRect.left;
    final rightBorderX = camera.visibleWorldRect.right;
    return world.addAll(
      [
        for (double y = camera.visibleWorldRect.bottom + wallSize * 0.5;
            y > camera.visibleWorldRect.top - wallSize;
            y -= wallSize) ...[
          Wall(
            Vector2(leftBorderX + wallSize * 0.25, y),
            metal.getSprite('elementMetal023.png'),
          ),
          Wall(
            Vector2(rightBorderX - wallSize * 0.25, y),
            metal.getSprite('elementMetal023.png'),
          ),
        ],
      ],
    );
  }

  Future<void> addBricks() async {
    for (var i = 0; i < 10; i++) {
      await world.add(randomBrick());

      await Future<void>.delayed(const Duration(milliseconds: 850));
    }
  }

  Brick randomBrick() {
    final type = BrickType.random();
    final size = BrickSize.random();

    return Brick(
      type: type,
      size: size,
      damage: BrickDamage.none,
      position: Vector2(
        camera.visibleWorldRect.right / 3 + (rand.nextDouble() * 5 - 2.5),
        0,
      ),
      sprites: brickFileNames(type, size).map(
        (key, filename) => MapEntry(
          key,
          elements.getSprite(filename),
        ),
      ),
    );
  }

  var enemiesFullyAdded = false;

  Future<void> addEnemies() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    for (var i = 0; i < 3; i++) {
      await world.add(
        Enemy(
          Vector2(
            camera.visibleWorldRect.right / 3 + (rand.nextDouble() * 7 - 3.5),
            (rand.nextDouble() * 3),
          ),
          aliens.getSprite(EnemyColor.random().fileName),
        ),
      );
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    enemiesFullyAdded = true; // To here.
  }

  Future<void> addPlayer() async => world.add(
        Player(
          Vector2(camera.visibleWorldRect.left * 2 / 3, 0),
          aliens.getSprite(PlayerColor.randomColor.fileName),
        ),
      );

  @override
  void update(double dt) {
    super.update(dt);
    if (isMounted && // Modify from here...
        world.children.whereType<Player>().isEmpty &&
        world.children.whereType<Enemy>().isNotEmpty) {
      addPlayer();
    }
    if (isMounted &&
        enemiesFullyAdded &&
        world.children.whereType<Enemy>().isEmpty &&
        world.children.whereType<TextComponent>().isEmpty) {
      world.addAll(
        [
          (position: Vector2(0.5, 0.5), color: Colors.white),
          (position: Vector2.zero(), color: Colors.orangeAccent),
        ].map(
          (e) => TextComponent(
            text: 'You win!',
            anchor: Anchor.center,
            position: e.position,
            textRenderer: TextPaint(
              style: TextStyle(color: e.color, fontSize: 16),
            ),
          ),
        ),
      );
    }
  }
}
