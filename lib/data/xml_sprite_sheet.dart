import 'dart:ui' as ui;

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

const double cutWidth = 0.1;
const double fullCut = cutWidth + cutWidth;

class XmlSpriteSheet {
  XmlSpriteSheet({
    required this.image,
    required String xml,
  }) {
    final document = XmlDocument.parse(xml);
    for (final node in document.xpath('//TextureAtlas/SubTexture')) {
      final name = node.getAttribute('name')!;

      final x = (double.parse(node.getAttribute('x')!) + cutWidth);
      // final y = (double.parse(node.getAttribute('y')!) + cutWidth);
      final width = (double.parse(node.getAttribute('width')!) - fullCut);
      // final height = (double.parse(node.getAttribute('height')!) - fullCut);

      // final x = double.parse(node.getAttribute('x')!);
      final y = double.parse(node.getAttribute('y')!);
      // final width = double.parse(node.getAttribute('width')!);
      final height = double.parse(node.getAttribute('height')!);

      _spriteBoundaries[name] = Rect.fromLTWH(x, y, width, height);
    }
  }

  /// Load an [XmlSpriteSheet] from an image and an XML file.
  ///
  /// The [imagePath] should be in relation to `assets/images/`.
  /// The [xmlPath] should be in relation to `assets/`.
  static Future<XmlSpriteSheet> load({
    required String imagePath,
    required String xmlPath,
    Images? imageCache,
    AssetsCache? assetsCache,
  }) async {
    final image = await (imageCache ?? Flame.images).load(imagePath);
    final xml = await (assetsCache ?? Flame.assets).readFile(xmlPath);
    return XmlSpriteSheet(image: image, xml: xml);
  }

  final ui.Image image;
  final _spriteBoundaries = <String, Rect>{};
  late final List<String> spriteNames = _spriteBoundaries.keys.toList();

  /// Get a sprite from the sprite sheet by its name.
  ///
  /// Throws an [ArgumentError] if the sprite is not found.
  Sprite getSprite(String name) {
    final rect = _spriteBoundaries[name];
    if (rect == null) {
      throw ArgumentError('Sprite $name could not be found');
    }
    return Sprite(
      image,
      srcPosition: rect.topLeft.toVector2(),
      srcSize: rect.size.toVector2(),
    );
  }

  /// Get a random sprite from the sprite sheet.
  Sprite getRandomSprite() => getSprite(spriteNames.random());
}
