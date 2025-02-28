import 'package:flutter/material.dart';

import 'tools/logger.dart';

class ImageSwapper extends StatelessWidget {
  final double deltaThreshold = 10;

  final String imageSource;
  final String? basicDescription;
  final void Function({bool forceUpdate})? onSwipe;
  final VoidCallback? onRight;
  final VoidCallback? onLeft;
  final VoidCallback? onExpand;

  double dragXStart = 0;
  double dragYStart = 0;

  ImageSwapper(
      {super.key,
      required this.imageSource,
      this.basicDescription,
      this.onSwipe,
      this.onLeft,
      this.onRight,
      this.onExpand});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        if (onExpand != null) onExpand!();
      },
      onPanDown: (details) {
        logger.info("PanDown");
        dragXStart = details.globalPosition.dx;
        dragYStart = details.globalPosition.dy;
      },
      onHorizontalDragEnd: (details) {
        var deltaX = details.globalPosition.dx - dragXStart;
        if (deltaX.abs() < deltaThreshold) return;
        if (deltaX > deltaThreshold && onRight != null) {
          onRight!();
        } else if (deltaX < -deltaThreshold && onLeft != null) {
          onLeft!();
        }
      },
      onVerticalDragEnd: (details) {
        var deltaY = details.globalPosition.dy - dragYStart;
        if ((deltaY).abs() > deltaThreshold && onSwipe != null) {
          onSwipe!(forceUpdate: true);
        }
      },
      child: Center(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).height * 0.75,
                  maxHeight: MediaQuery.sizeOf(context).height * 0.75,
                  maxWidth: MediaQuery.sizeOf(context).width * 0.9),
              child: AspectRatio(
                aspectRatio: 0.7,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(children: [
                      SizedBox(
                          height: double.infinity,
                          child: Image.network(imageSource, fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
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
                      basicDescription != null
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                  width: double.infinity,
                                  child: Card.filled(
                                      color: const Color.fromARGB(200, 0, 0, 0),
                                      child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            basicDescription!,
                                            softWrap: true,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                overflow: TextOverflow.fade),
                                          )))))
                          : Container()
                    ])),
              ))),
    );
  }
}
