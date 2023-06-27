import 'package:flutter/material.dart';
import 'SquareSliderComponentShape.dart';

class DiarySlider extends StatefulWidget {
  final double maxRange;
  final double currSelect;

  const DiarySlider({super.key, required this.maxRange, this.currSelect = 1});

  @override
  State<DiarySlider> createState() => _DiarySliderState();
}

class _DiarySliderState extends State<DiarySlider> {
  late double _currentSliderValue = widget.currSelect;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        thumbColor: Color(0xfff4c758),
        thumbShape: SquareSliderComponentShape(),
        activeTrackColor: Color(0xffd9d9d9),
        inactiveTrackColor: Color(0xffd9d9d9),
        trackHeight: 8,
        activeTickMarkColor: Color(0xffc9c9c9),
        inactiveTickMarkColor: Color(0xffc9c9c9),
        showValueIndicator: ShowValueIndicator.never,
        // val
      ),
      child: Slider(
        value: _currentSliderValue,
        min: 1,
        max: widget.maxRange,
        divisions: (widget.maxRange - 1).toInt(),
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
          });
        },
      ),
    );
  }
}
