import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MyPlatformerGame game = MyPlatformerGame();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(game: game),

            // 🔥 모바일(앱)에서만 점프 버튼 표시
            if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
              Positioned(
                bottom: 50,
                right: 30,
                child: GestureDetector(
                  onTap: () => game.player.jump(),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_upward, color: Colors.white, size: 40),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
