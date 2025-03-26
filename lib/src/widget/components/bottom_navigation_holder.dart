import 'package:flutter/material.dart';

class BottomNavigationHolder extends StatelessWidget {
  final List<Widget> children;

  const BottomNavigationHolder({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color.fromARGB(255, 50, 50, 50)
                    : const Color.fromARGB(255, 200, 200, 200),
                width: 3)),
        child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            )));
  }
}
