import 'dart:ui';

import '../game_controller.dart';

class Player {
  final GameController gameController;
  int maxHealth;
  int currentHealth;
  bool isDead = false;
  Rect playerRect;

  Player(this.gameController) {
    maxHealth = currentHealth = 300;
    final size = gameController.tileSize * 1.5;
    playerRect = Rect.fromLTWH(
        (gameController.screenSize.width / 2) - (size / 2),
        (gameController.screenSize.height / 2) - (size / 2),
        size,
        size);
  }

  void render(Canvas canvas){
    Paint paint = Paint()..color = Color(0xff0000ff);
    canvas.drawRect(playerRect, paint);
  }

  void update(double t){
    if(!isDead && currentHealth <= 0){
      isDead = true;
      gameController.initialize();
    }
  }

}
