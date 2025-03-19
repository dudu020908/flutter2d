import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Background extends SpriteComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('background.png');
    size = gameRef.size; // 화면 크기에 맞춤
  }
}
