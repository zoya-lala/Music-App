import 'dart:math';

import 'package:flutter/material.dart';

class WaveformVisualizer extends CustomPainter {
  final double progress;

  WaveformVisualizer(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final midHeight = size.height / 2;
    final barWidth = 6.0;
    final spacing = 8.0;
    final completedWidth = size.width * progress;

    for (double i = 0; i < completedWidth; i += barWidth + spacing) {
      final barHeight = (midHeight / 2) * sin(i / size.width * 2 * pi);

      paint.color = Colors.white;
      canvas.drawLine(
        Offset(i, midHeight - barHeight),
        Offset(i, midHeight + barHeight),
        paint,
      );
    }

    for (double i = completedWidth; i < size.width; i += barWidth + spacing) {
      final barHeight = (midHeight / 2) * sin(i / size.width * 2 * pi);

      paint.color = Colors.grey;
      canvas.drawLine(
        Offset(i, midHeight - barHeight),
        Offset(i, midHeight + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
