import 'dart:ui';

import 'package:taptokill/game_controller.dart';

class Enemy {
  final GameController gameController;
  int health;
  int damage;
  double speed;
  Rect enemyRect;
  bool isDead = false;

  Enemy(this.gameController, double x, double y) {
    health = 3;
    damage = 1;
    speed = gameController.tileSize * 2;
    enemyRect = Rect.fromLTWH(
        x, y, gameController.tileSize * 1.2, gameController.tileSize * 1.2);
  }

  void render(Canvas canvas) {
    Color color;
    switch (health) {
      case 1:
        color = Color(0xffff7f7f);
        break;
      case 2:
        color = Color(0xffff4c4c);
        break;
      case 3:
        color = Color(0xffff4500);
        break;
      default:
        color = Color(0xffff0000);
        break;
    }
    Paint paint = Paint()..color = color;
    canvas.drawRect(enemyRect, paint);
  }



  void update(double t) {
    if(!isDead){
      double stepDistance = speed * t;
      Offset toPlayer = gameController.player.playerRect.center - enemyRect.center;
      if(stepDistance <= toPlayer.distance - gameController.tileSize * 1.25){
        Offset stepToPlayer = Offset.fromDirection(toPlayer.direction, stepDistance);
        enemyRect = enemyRect.shift(stepToPlayer);
      } else {
        attack();
      }
    }
  }

  void attack(){
    if(!gameController.player.isDead){
      gameController.player.currentHealth -= damage;
    }
  }

  void onTap() {
    if(!isDead) {
      health--;
      if (health <= 0) {
        isDead = true;
        gameController.score++;
        if(gameController.score > (gameController.storage.getInt('highscore') ?? 0)){
          gameController.storage.setInt('highscore', gameController.score);
        }
      }
    }
  }
}
