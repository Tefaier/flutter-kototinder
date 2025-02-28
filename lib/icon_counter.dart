import 'package:flutter/material.dart';

class IconCounter extends StatelessWidget {
  final ImageIcon icon;
  final int number;

  const IconCounter({super.key, required this.icon, required this.number});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        icon,
        FittedBox(fit: BoxFit.fitHeight, child: Text(
          "$number", style: const TextStyle(fontSize: 25),
        )) 
      ],
    );
  }
}
