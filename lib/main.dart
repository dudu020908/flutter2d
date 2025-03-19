import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MyPlatformerGame game = MyPlatformerGame();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => game.focusNode.requestFocus(), // 터치하면 게임 화면에 포커스 설정
      child: KeyboardListener(
        focusNode: game.focusNode, // FocusNode 연결
        onKeyEvent: (KeyEvent event) => game.onKeyEvent(event,HardwareKeyboard.instance.logicalKeysPressed), // 🔥 타입 변경
        child: GameWidget(game: game),
      ),
    );
  }
}
