import 'package:cached_network_image/cached_network_image.dart';
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
    return Hero(
        tag: url,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          progressIndicatorBuilder: (context, url, loadingProgress) {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.progress,
              ),
            );
          },
          imageBuilder: (context, imageProvider) {
            return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 200),
                builder: (BuildContext context, double opacity, Widget? child) {
                  return Opacity(opacity: opacity, child: child);
                },
                child: Image(
                  image: imageProvider,
                ));
          },
          errorWidget: (context, url, error) {
            getIt<NavigationManager>().showAlert(
                "Internet error", "Failed to load image by url $url}");
            return const Icon(Icons.error);
          },
        ));
  }
}
