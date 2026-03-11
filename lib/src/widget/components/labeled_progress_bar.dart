import 'package:flutter/material.dart';

class ProgressbarWithText extends StatelessWidget {
  final String text;
  final int currentValue;
  final int minValue;
  final int maxValue;
  final double barHeight;
  final Color barFillColor;
  final Color barBackColor;

  const ProgressbarWithText({
    super.key,
    required this.text,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    required this.barHeight,
    required this.barFillColor,
    required this.barBackColor,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentValue - minValue) / (maxValue - minValue);


    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 4,
      children: [
        Text(text,
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        const SizedBox(width: 20),
        Text(
          minValue.toString(),
          style: const TextStyle(fontSize: 12),
        ),
        Container(
            width: 100,
            height: barHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(barHeight / 2),
              color: barBackColor,
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(barHeight / 2),
                      color: barBackColor,
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(barHeight / 2),
                      color: barFillColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Text(
          maxValue.toString(),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
