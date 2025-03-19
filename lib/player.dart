import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'game.dart';
import 'platform.dart';
import 'obstacle.dart';

class Player extends SpriteComponent with HasGameRef<MyPlatformerGame>, CollisionCallbacks {
  static const double gravity = 600;
  static const double jumpForce = -300;
  static const double speed = 200;
  double velocityY = 0;
  bool isOnGround = false;
  Vector2 moveDirection = Vector2.zero();

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player.png');
    size = Vector2(50, 50);
    position = Vector2(100, gameRef.size.y - 150);
    add(RectangleHitbox()); // 🔥 충돌 감지 추가
  }

  void jump() {
    if (isOnGround) {
      velocityY = jumpForce;
      isOnGround = false;
    }
  }

  void moveLeft() {
    moveDirection.x = -1;
  }

  void moveRight() {
    moveDirection.x = 1;
  }

  void stopMoving() {
    moveDirection.x = 0;
  }

  void updateJoystick(Vector2 joystickDelta) {
    if (joystickDelta.x.abs() > 0.1) {
      moveDirection.x = joystickDelta.x.sign;
    } else {
      stopMoving();
    }
  }

  @override
  void update(double dt) {
    velocityY += gravity * dt;
    position.y += velocityY * dt;
    position.x += moveDirection.x * speed * dt;

    position.x = position.x.clamp(0, gameRef.size.x - size.x);

    if (position.y >= gameRef.size.y - size.y) {
      position.y = gameRef.size.y - size.y;
      velocityY = 0;
      isOnGround = true;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Platform) {
      if (velocityY > 0) {
        position.y = other.position.y - size.y;
        velocityY = 0;
        isOnGround = true;
      }
    }

    if (other is Obstacle) {
      position = Vector2(100, gameRef.size.y - 150);
      velocityY = 0;
      isOnGround = true;
    }
  }

  void handleKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        moveLeft();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        moveRight();
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        jump();
      }
    }

    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowRight) {
        stopMoving();
      }
    }
  }
}
