import 'package:flutter_hw_lototinder/src/domain/model/awailable_apis.dart';
import 'package:flutter_hw_lototinder/src/domain/state/images_loader.dart';
import 'package:flutter_test/flutter_test.dart';

// it would be better to mock http.get but I didn't find a way to do so
// also it was found out that during tests all requests fail (infinite)
void main() {
  setUp(() {
    ImagesLoader.currentRequestsCount.clear();
  });

  test(
    'Проверка загрузки',
    () async {
      int counterOnLoad = 0;
      int counterOnError = 0;

      ImagesLoader loader = ImagesLoader();
      loader.loadImagesUpTo(10, () => 3, AwailableAPIs.test, (info) { counterOnLoad+=1; }, () { counterOnError+=1; });

      expect(ImagesLoader.currentRequestsCount[AwailableAPIs.test], equals(7 - counterOnLoad));
      expect(counterOnError, equals(0));
    },
  );
}
