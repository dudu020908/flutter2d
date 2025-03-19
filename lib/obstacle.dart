import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/painting.dart';
import 'game.dart';

class Obstacle extends PositionComponent with HasGameRef<MyPlatformerGame>, CollisionCallbacks {
  Obstacle(Vector2 position, Vector2 size) {
    this.position = position;
    this.size = size;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFFFF0000);
    canvas.drawRect(size.toRect(), paint);
  }
}
