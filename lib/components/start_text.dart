import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:taptokill/game_controller.dart';

class StartText {
  final GameController gameController;
  TextPainter painter;
  Offset position;

  StartText(this.gameController){
    painter = TextPainter(textAlign: TextAlign.center,
      textDirection: TextDirection.ltr
    );
    position = Offset.zero;
  }

  void render(Canvas canvas) {
    painter.paint(canvas, position);
  }

  void update(double t) {
    painter.text = TextSpan(
        text: 'Start',
        style: TextStyle(color: Colors.black, fontSize: 50.0));
    painter.layout();

    position = Offset(
        (gameController.screenSize.width / 2) - (painter.width / 2),
        (gameController.screenSize.height * 0.7) - (painter.height / 2));
  }

}