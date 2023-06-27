import 'package:flutter/material.dart';
import 'package:sumday/providers/generate_provider.dart';
import 'SquareSliderComponentShape.dart';
import 'package:provider/provider.dart';

class DiarySlider extends StatefulWidget {
  final double maxRange;

  const DiarySlider({super.key, required this.maxRange});

  @override
  State<DiarySlider> createState() => _DiarySliderState();
}

class _DiarySliderState extends State<DiarySlider> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GenerateProvider>(
      builder: (context, generateProvider, _) {
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
            value: generateProvider.sliderValue,
            min: 1,
            max: widget.maxRange,
            divisions: widget.maxRange == 1 ? 1 : (widget.maxRange - 1).toInt(),
            onChanged: (double value) {
              setState(() {
                generateProvider.setPageValue((value - 1).toInt());
                generateProvider.setSliderValue(value);
              });
            },
          ),
        );
      },
    );
  }
}
