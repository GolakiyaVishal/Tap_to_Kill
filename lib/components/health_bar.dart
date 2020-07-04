import 'dart:ui';

import 'package:taptokill/game_controller.dart';

class HealthBar {
  final GameController gameController;
  Rect healthBarRect;
  Rect remainingHealthRect;
  double barWidth;

  HealthBar(this.gameController) {
    barWidth = gameController.screenSize.width / 1.75;
    healthBarRect = Rect.fromLTWH(
        gameController.screenSize.width / 2 - barWidth / 2,
        gameController.screenSize.height * 0.8,
        barWidth,
        gameController.tileSize * 0.5);
    remainingHealthRect = Rect.fromLTWH(
        gameController.screenSize.width / 2 - barWidth / 2,
        gameController.screenSize.height * 0.8,
        barWidth,
        gameController.tileSize * 0.5);
  }

  void render(Canvas canvas) {
    Paint healthColor = Paint()..color = Color(0xffff0000);
    Paint remainingHealthColor = Paint()..color = Color(0xff00ff00);

    canvas.drawRect(healthBarRect, healthColor);
    canvas.drawRect(remainingHealthRect, remainingHealthColor);
  }

  void update(double t) {
    double percentHealth =
        gameController.player.currentHealth / gameController.player.maxHealth;
    remainingHealthRect = Rect.fromLTWH(
        gameController.screenSize.width / 2 - barWidth / 2,
        gameController.screenSize.height * 0.8,
        barWidth * percentHealth,
        gameController.tileSize * 0.5);
  }
}
