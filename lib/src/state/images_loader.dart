import 'package:flutter_hw_lototinder/src/model/awailable_apis.dart';
import 'package:flutter_hw_lototinder/src/model/image_info.dart';
import 'package:flutter_hw_lototinder/src/utils/api_requests.dart';

class ImagesLoader {
  static const int keepLoadedSetting = 3;
  static const Duration reloadDelay = Duration(seconds: 10);
  static Map<AwailableAPIs, int> currentRequestsCount = {};

  loadImages(int count, AwailableAPIs fromAPI,
      void Function(ImageInfo) onLoadCallback, void Function()? onLoadFail) {
    for (var _ in List.generate(count, (index) => 0)) {
      currentRequestsCount.update(fromAPI, (prev) => prev + 1);
      ApiRequests.makeRequest(fromAPI, onLoadFail).then((value) {
        if (value == null) {
          Future.delayed(
              reloadDelay, () => loadImages(1, fromAPI, onLoadCallback, onLoadFail));
          return;
        }
        currentRequestsCount.update(fromAPI, (prev) => prev - 1);
        onLoadCallback(value);
      });
    }
  }

  loadImagesUpTo(int upto, int Function() countChecker, AwailableAPIs fromAPI,
      void Function(ImageInfo) onLoadCallback, void Function()? onLoadFail) {
    currentRequestsCount.putIfAbsent(fromAPI, () => 0);
    var current = countChecker() + currentRequestsCount[fromAPI]!;
    if (current >= upto) return;
    loadImages(upto - current, fromAPI, onLoadCallback, onLoadFail);
  }
}
