import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'game.dart';
import 'platform.dart';
import 'obstacle.dart';

class Player extends SpriteComponent with HasGameRef<MyPlatformerGame>, CollisionCallbacks { // 🔥 충돌 감지 추가
  static const double gravity = 600;
  static const double jumpForce = -300;
  static const double speed = 200;
  double velocityY = 0;
  double velocityX = 0;
  bool isOnGround = false; // 🔥 바닥에 있는지 여부 확인

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player.png');
    size = Vector2(50, 50);
    position = Vector2(100, gameRef.size.y - 150); // 시작 위치 조정
    add(RectangleHitbox()); // 🔥 충돌 감지 추가
  }

  void jump() {
    if (isOnGround) { // 🔥 바닥에 있을 때만 점프 가능
      velocityY = jumpForce;
      isOnGround = false;
      print("점프!");
    }
  }

  @override
  void update(double dt) {
    velocityY += gravity * dt; // 중력 적용
    position.y += velocityY * dt;
    position.x += velocityX * dt;

    // 🔥 화면 경계를 벗어나지 않도록 제한
    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;

    if (position.x < 0) {
      position.x = 0;
    }
    if (position.x + size.x > screenWidth) {
      position.x = screenWidth - size.x;
    }

    if (position.y >= screenHeight - size.y) {
      position.y = screenHeight - size.y;
      velocityY = 0;
      isOnGround = true;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Platform) {
      if (velocityY > 0) { // 아래로 떨어질 때만 반응
        position.y = other.position.y - size.y; // 🔥 플랫폼 위에 착지
        velocityY = 0;
        isOnGround = true;
      }
    }

    if (other is Obstacle) {
      position = Vector2(100, gameRef.size.y - 150); // 플레이어 초기 위치로 이동
      velocityY = 0;
      isOnGround = true;
    }
  }

  void handleKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        velocityX = -speed;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        velocityX = speed;
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        jump();
      }
    }

    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowRight) {
        velocityX = 0;
      }
    }
  }
}
