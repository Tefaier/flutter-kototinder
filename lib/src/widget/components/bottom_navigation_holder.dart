import 'package:flutter/material.dart';

class BottomNavigationHolder extends StatelessWidget {
  final List<Widget> children;

  const BottomNavigationHolder({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.light ? const Color.fromARGB(255, 240, 240, 255) : const Color.fromARGB(255, 10, 10, 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),),
        child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: children.length > 1 ? WrapAlignment.spaceBetween : WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              spacing: 0,
              runSpacing: 5,
              children: children,
            )));
  }
}
