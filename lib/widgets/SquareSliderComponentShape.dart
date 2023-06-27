import 'package:flutter/material.dart';

class SquareSliderComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(54, 16);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    canvas.drawShadow(
      Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            // 그림자?
            Rect.fromCenter(center: center, width: 58, height: 16),
            const Radius.circular(6),
          ),
        ),
      Colors.black,
      5,
      false,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        // 슬라이더 크기
        Rect.fromCenter(center: center, width: 54, height: 16),
        const Radius.circular(6),
      ),
      Paint()..color = Color(0xfff4c758),
    );
  }
}
