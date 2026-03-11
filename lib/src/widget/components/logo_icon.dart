import 'package:flutter/material.dart';

class LogoIcon extends StatelessWidget {
  const LogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          MediaQuery.sizeOf(context).shortestSide * 0.1 * 0.2),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Image(
          image: const AssetImage("assets/Kototinder_icon.png"),
          width: MediaQuery.sizeOf(context).shortestSide * 0.1,
          height: MediaQuery.sizeOf(context).shortestSide * 0.1),
    );
  }
}
