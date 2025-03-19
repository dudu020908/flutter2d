import 'dart:io' if (dart.library.html) 'dart:html'; // 웹과 네이티브 지원
import 'package:flutter/foundation.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'background.dart';
import 'player.dart';
import 'platform.dart';
import 'obstacle.dart';

class MyPlatformerGame extends FlameGame with KeyboardEvents, HasCollisionDetection { // 🔥 충돌 감지 활성화
  late Player player;
  late Background background;
  JoystickComponent? joystick;

  @override
  Future<void> onLoad() async {
    background = Background();
    background.priority = -1;
    add(background);

    player = Player();
    player.priority = 1;
    add(player);

    // 땅(플랫폼) 추가
    add(Platform(Vector2(100, size.y - 50), Vector2(300, 20))); // 바닥
    add(Platform(Vector2(400, size.y - 150), Vector2(200, 20))); // 공중 플랫폼

    // 장애물 추가
    add(Obstacle(Vector2(250, size.y - 70), Vector2(40, 40)));
    add(Obstacle(Vector2(450, size.y - 170), Vector2(40, 40)));

    // 모바일에서 조이스틱 추가
    if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
      joystick = JoystickComponent(
        knob: CircleComponent(radius: 20, paint: Paint()..color = const Color(0xFFCCCCCC)),
        background: CircleComponent(radius: 50, paint: Paint()..color = const Color(0x88000000)),
        margin: const EdgeInsets.only(left: 30, bottom: 30),
      );
      add(joystick!);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 모바일에서 조이스틱 입력 적용
    if (joystick != null) {
      player.updateJoystick(joystick!.relativeDelta);
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // 웹 및 데스크톱 환경에서 키보드 입력 적용
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      player.handleKeyEvent(event, keysPressed);
    }
    return KeyEventResult.handled;
  }
}
