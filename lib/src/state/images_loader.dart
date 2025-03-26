import 'package:flutter_hw_lototinder/src/model/awailable_apis.dart';
import 'package:flutter_hw_lototinder/src/model/image_info.dart';
import 'package:flutter_hw_lototinder/src/utils/api_requests.dart';

class ImagesLoader {
  static const int keepLoadedSetting = 3;
  static const Duration reloadDelay = Duration(seconds: 10);

  loadImages(int count, AwailableAPIs fromAPI,
      void Function(ImageInfo) onLoadCallback) {
    for (var _ in List.generate(count, (index) => 0)) {
      ApiRequests.makeRequest(fromAPI).then((value) {
        if (value == null) {
          Future.delayed(
              reloadDelay, () => loadImages(1, fromAPI, onLoadCallback));
          return;
        }
        onLoadCallback(value);
      });
    }
  }

  loadImagesUpTo(int upto, int Function() countChecker, AwailableAPIs fromAPI,
      void Function(ImageInfo) onLoadCallback) {
    var current = countChecker();
    if (current >= upto) return;
    loadImages(upto - current, fromAPI, onLoadCallback);
  }
}
