import 'package:flutter/material.dart';

class IconButtonCounter extends StatelessWidget {
  final ImageIcon icon;
  final int number;
  final VoidCallback? onClick;

  const IconButtonCounter(
      {super.key, required this.icon, required this.number, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 0,
      children: [
        IconButton(onPressed: onClick, icon: icon),
        SizedBox(
            height: icon.size,
            width: icon.size,
            child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "$number",
                  style: const TextStyle(fontSize: 25),
                )))
      ],
    );
  }
}
