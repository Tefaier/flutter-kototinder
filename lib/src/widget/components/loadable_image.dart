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
            return Image(
              image: imageProvider,
              fit: fit
            );
          },
          errorWidget: (context, url, error) {
            getIt<NavigationManager>().showAlert(
                "Internet error", "Failed to load image by url $url}");
            return const Icon(Icons.error);
          },
        ));
  }
}
