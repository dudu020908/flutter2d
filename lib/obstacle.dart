import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Obstacle extends PositionComponent with CollisionCallbacks { // 🔥 충돌 감지 추가
  Obstacle(Vector2 position, Vector2 size) {
    this.position = position;
    this.size = size;
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox()); // 🔥 충돌 감지를 위한 Hitbox 추가
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.red;
    canvas.drawRect(size.toRect(), paint);
  }
}
