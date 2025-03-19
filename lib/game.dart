import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart'; // 🔥 충돌 감지를 위한 추가
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'player.dart';
import 'background.dart';
import 'platform.dart';
import 'obstacle.dart';

class MyPlatformerGame extends FlameGame with KeyboardEvents, HasCollisionDetection { // 🔥 충돌 감지 추가
  late Player player;
  final FocusNode focusNode = FocusNode(); // 키 입력 감지용 FocusNode 추가

  @override
  Future<void> onLoad() async {
    add(Background());
    player = Player();
    add(player);

    // 🔥 플랫폼 추가
    add(Platform(Vector2(200, 800), Vector2(300, 20))); // 낮은 플랫폼
    add(Platform(Vector2(500, 700), Vector2(200, 20))); // 높은 플랫폼

    // 🔥 장애물 추가
    add(Obstacle(Vector2(350, 780), Vector2(30, 30))); // 장애물 1
    add(Obstacle(Vector2(600, 680), Vector2(30, 30))); // 장애물 2

    add(ScreenHitbox()); // 🔥 화면 경계 충돌 활성화
  }

  @override
  void onAttach() {
    super.onAttach();
    focusNode.requestFocus(); // 게임이 실행될 때 포커스 설정
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    player.handleKeyEvent(event, keysPressed);
    return KeyEventResult.handled;
  }
}
