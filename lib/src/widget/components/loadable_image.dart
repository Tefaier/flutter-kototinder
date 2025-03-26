import 'package:flutter/material.dart';

class LoadableImage extends StatelessWidget {
  String url;
  BoxFit fit;

  LoadableImage({super.key, required this.url, required this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.network(url, fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
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
    });
  }
}
