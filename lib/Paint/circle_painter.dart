import 'package:ciao_app/others/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CirclePainter extends CustomPainter {
  final double waveRadius;
  var wavePaint;

  CirclePainter(this.waveRadius) {
    wavePaint = Paint()
      ..color = Colors.white10.withOpacity(.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / .5;
    double maxRadius = hypot(centerX, centerY) - 10;

    double currentRadius = waveRadius;
    while (currentRadius < maxRadius) {
      canvas.drawCircle(Offset(centerX, centerY), currentRadius, wavePaint);
      currentRadius += 10.0;
    }
  }

  double hypot(double x, double y) {
    return math.sqrt(x * x + y * y);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return false;
  }
}
