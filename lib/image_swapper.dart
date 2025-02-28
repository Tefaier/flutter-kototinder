import 'dart:math';

import 'package:flutter/material.dart';

import 'tools/logger.dart';

class ImageSwapper extends StatefulWidget {
  final String imageSource;
  final String? basicDescription;
  final void Function({bool forceUpdate})? onSwipe;
  final VoidCallback? onRight;
  final VoidCallback? onLeft;
  final VoidCallback? onExpand;

  const ImageSwapper(
      {super.key,
      required this.imageSource,
      this.basicDescription,
      this.onSwipe,
      this.onLeft,
      this.onRight,
      this.onExpand});

  @override
  State<ImageSwapper> createState() => _ImageSwapperState();
}

class _ImageSwapperState extends State<ImageSwapper> {
  final double deltaThreshold = 50;

  double dragXStart = 0;
  double dragYStart = 0;
  double currentDX = 0;
  double currentDY = 0;

  double computeOffset(double delta, double limit, double sensitivity) {
    if (delta.abs() < deltaThreshold) return 0;
    return limit * atan((delta - deltaThreshold * delta.sign) * sensitivity) * 2 / pi;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        if (widget.onExpand != null) widget.onExpand!();
      },
      onPanDown: (details) {
        dragXStart = details.globalPosition.dx;
        dragYStart = details.globalPosition.dy;
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          currentDX = details.globalPosition.dx - dragXStart;
        });
      },
      onVerticalDragUpdate: (details) {
        setState(() {
          currentDY = details.globalPosition.dy - dragYStart;
        });
      },
      onHorizontalDragEnd: (details) {
        if (currentDX.abs() < deltaThreshold) return;
        if (currentDX > deltaThreshold && widget.onRight != null) {
          widget.onRight!();
        } else if (currentDX < -deltaThreshold && widget.onLeft != null) {
          widget.onLeft!();
        }
        currentDX = 0;
      },
      onVerticalDragEnd: (details) {
        if ((currentDY).abs() > deltaThreshold && widget.onSwipe != null) {
          widget.onSwipe!(forceUpdate: true);
        }
        currentDY = 0;
      },
      child: Center(
          child: Transform.translate(
              offset: Offset(
                  computeOffset(
                      currentDX,
                      MediaQuery.sizeOf(context).height * 0.05,
                      20 / MediaQuery.sizeOf(context).shortestSide),
                  computeOffset(
                      currentDY,
                      MediaQuery.sizeOf(context).width * 0.05,
                      20 / MediaQuery.sizeOf(context).shortestSide)),
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.sizeOf(context).height * 0.8,
                      maxHeight: MediaQuery.sizeOf(context).height * 0.8,
                      maxWidth: MediaQuery.sizeOf(context).width * 0.9),
                  child: AspectRatio(
                    aspectRatio: 0.7,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(children: [
                          SizedBox(
                              height: double.infinity,
                              child: Image.network(widget.imageSource,
                                  fit: BoxFit.cover, loadingBuilder:
                                      (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              }, frameBuilder: (_, child, frame, ___) {
                                return AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: frame != null ? 1.0 : 0,
                                  child: frame != null ? child : Container(),
                                );
                              })),
                          widget.basicDescription != null
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Card.filled(
                                          color: const Color.fromARGB(
                                              200, 0, 0, 0),
                                          child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                widget.basicDescription!,
                                                softWrap: true,
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    overflow:
                                                        TextOverflow.fade),
                                              )))))
                              : Container()
                        ])),
                  )))),
    );
  }
}
