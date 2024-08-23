import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

void main() async {
  final file = File('assets/tiles/spritesheet_elements.xml');
  final rects = <String, Rect>{};
  final document = XmlDocument.parse(file.readAsStringSync());
  for (final node in document.xpath('//TextureAtlas/SubTexture')) {
    final name = node.getAttribute('name')!;
    rects[name] = Rect(
      x: int.parse(node.getAttribute('x')!),
      y: int.parse(node.getAttribute('y')!),
      width: int.parse(node.getAttribute('width')!),
      height: int.parse(node.getAttribute('height')!),
    );
  }

  final generatedBricks = generateBrickFileNames(rects);
  await writeGenerated(generatedBricks);

  stdout.write('All done!\n');
}

Future<void> writeGenerated(StringBuffer generated) async {
  // Creates lib/generated/.
  await Directory('lib/generated').create(recursive: true);

  /// Creates and writes into file
  final genFile = File('lib/generated/brick_file_names.dart')
      .openWrite(mode: FileMode.writeOnly);
  genFile.write(generated);
  await genFile.flush();
  await genFile.close();
}

StringBuffer generateBrickFileNames(Map<String, Rect> rects) {
  final groups = <Size, List<String>>{};
  for (final entry in rects.entries) {
    groups.putIfAbsent(entry.value.size, () => []).add(entry.key);
  }
  final buff = StringBuffer();
  buff.writeln('''
part of '../components/brick.dart';

Map<BrickDamage, String> brickFileNames(BrickType type, BrickSize size) {
  return switch ((type, size)) {''');
  for (final entry in groups.entries) {
    final size = entry.key;
    final entries = entry.value;
    entries.sort();
    for (final type in ['Explosive', 'Glass', 'Metal', 'Stone', 'Wood']) {
      var filtered = [...entries.where((element) => element.contains(type))];
      late final String none, some, lots;
      switch (filtered.length) {
        case 5:
          [none, some, lots] = [filtered[0], filtered[1], filtered[4]];
          continue pushToBuffer;
        case 10:
          [none, some, lots] = [filtered[3], filtered[4], filtered[9]];
          continue pushToBuffer;
        case 15:
          [none, some, lots] = [filtered[7], filtered[8], filtered[13]];
          continue pushToBuffer;

        pushToBuffer:
        case -1:
          buff.writeln('''
    (BrickType.${type.toLowerCase()}, BrickSize.size${size.width}x${size.height}) => {
        BrickDamage.none: '$none',
        BrickDamage.some: '$some',
        BrickDamage.lots: '$lots',
      },''');
          break;
        default:
          break;
      }
    }
  }

  buff.writeln('''
  };
}''');

  return buff;
}

class Rect extends Equatable {
  final int x;
  final int y;
  final int width;
  final int height;

  const Rect({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  Size get size => Size(width, height);

  @override
  List<Object?> get props => [x, y, width, height];

  @override
  bool get stringify => true;
}

class Size extends Equatable {
  final int width;
  final int height;
  const Size(this.width, this.height);

  @override
  List<Object?> get props => [width, height];

  @override
  bool get stringify => true;
}
