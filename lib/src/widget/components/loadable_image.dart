import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/navigation/navigation_manager.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance();

class LoadableImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const LoadableImage({super.key, required this.url, required this.fit});

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
      return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 200),
          builder: (BuildContext context, double opacity, Widget? child) {
            return Opacity(opacity: opacity, child: child);
          },
          child: child);
    }, errorBuilder: (context, error, stackTrace) {
      getIt<NavigationManager>().showAlert("Internet error", "Failed to load image by url $url}");
      throw error;
    },);
  }
}
