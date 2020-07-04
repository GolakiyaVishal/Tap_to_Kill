import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taptokill/components/enemy.dart';
import 'package:taptokill/components/health_bar.dart';
import 'package:taptokill/components/high_score_text.dart';
import 'package:taptokill/components/player.dart';
import 'package:taptokill/components/start_text.dart';
import 'package:taptokill/enemy_spawner.dart';
import 'package:taptokill/mode.dart';

import 'components/score_text.dart';

class GameController extends Game with TapDetector {
  final SharedPreferences storage;
  Random rand;
  Size screenSize;
  double tileSize;
  Player player;
  EnemySpawner enemySpawner;
  List<Enemy> enemies;
  HealthBar healthBar;
  int score;
  ScoreText scoreText;
  Mode mode;
  HighScoreText highScoreText;
  StartText startText;

  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    mode = Mode.menu;
    rand = Random();
    player = Player(this);
    enemies = List<Enemy>();
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highScoreText = HighScoreText(this);
    startText = StartText(this);
  }

  @override
  void render(Canvas canvas) {
    Rect background =
        Rect.fromLTWH(0.0, 0.0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    canvas.drawRect(background, backgroundPaint);

    player.render(canvas);
    if(mode == Mode.menu){
      startText.render(canvas);
      highScoreText.render(canvas);
    } else if(mode == Mode.playing){
      enemies.forEach((element) => element.render(canvas));
      scoreText.render(canvas);
      healthBar.render(canvas);
    }
  }

  @override
  void update(double t) {
    if(mode == Mode.menu){
      startText.update(t);
      highScoreText.update(t);
    } else if(mode == Mode.playing) {
      enemySpawner.update(t);
      enemies.forEach((element) => element.update(t));
      enemies.removeWhere((enemy) => enemy.isDead);
      scoreText.update(t);
      player.update(t);
      healthBar.update(t);
    }
  }

  @override
  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  @override
  void onTapDown(TapDownDetails d) {
    if(mode == Mode.menu){
      mode = Mode.playing;
    } else if(mode == Mode.playing) {
      enemies.forEach((enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTap();
        }
      });
    }
  }

  void spawnEnemy() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        //Top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        //Right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        //Bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
        //Left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }
}
