import 'package:flutter_hw_lototinder/src/domain/dao/likes_history_dao.dart';
import 'package:flutter_hw_lototinder/src/domain/model/app_state.dart';
import 'package:flutter_hw_lototinder/src/domain/model/awailable_apis.dart';
import 'package:flutter_hw_lototinder/src/domain/model/image_info.dart';
import 'package:flutter_hw_lototinder/src/domain/model/like_interaction.dart';
import 'package:flutter_hw_lototinder/src/domain/state/images_history_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../dao/mock_likes_history_dao.dart';

void main() {
  late final ImagesNotifier imagesNotifier;
  late final LikesHistoryDao likesHistoryDao;
  const imageUrls = [
    "https://images.com/1.png",
    "https://images.com/2.png",
    "https://images.com/3.png"
  ];
  final imageInfos = imageUrls
      .map((e) => ImageInfo(
          apiSource: AwailableAPIs.cats,
          url: e,
          imageName: "cat",
          extraInfo: {}))
      .toList();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    likesHistoryDao = MockLikesHistoryDao();
    when(() => likesHistoryDao.loadItems()).thenAnswer((_) async => Future.value(<LikeInteraction>[]));
    imagesNotifier = ImagesNotifier(value: AppState(dao: likesHistoryDao));
    registerFallbackValue(LikeInteraction(imageInfo: ImageInfo(apiSource: AwailableAPIs.test, url: "", imageName: ""), actionTime: DateTime.now()));
  });

  tearDownAll(() {
    reset(likesHistoryDao);
  });

  setUp(() {
    reset(likesHistoryDao);
    imagesNotifier.value.localHistory = [];
    imagesNotifier.value.loadedImages = {};
  });

  test(
    'Проверка синхронизации с репозиторием',
    () async {
      when(() => likesHistoryDao.loadItems()).thenAnswer(
        (_) async {
          return Future.value([
            LikeInteraction(
                imageInfo: imageInfos[0], actionTime: DateTime.now()),
            LikeInteraction(
                imageInfo: imageInfos[1], actionTime: DateTime.now())
          ]);
        },
      );

      expect(imagesNotifier.value.localHistory.length, 0);

      await imagesNotifier.synchWithRepository();
      expect(imagesNotifier.value.localHistory.length, 2);
      verify(() => likesHistoryDao.loadItems()).called(1);
    },
  );

  group(
    'Проверка сохранения данных',
    () {
      test(
        'Успешное сохранения лайков и дизлайков',
        () async {
          when(() => likesHistoryDao.saveItem(any())).thenAnswer(
            (_) async {},
          );

          imagesNotifier.addLike(imageInfos[0]);
          imagesNotifier.addDislike(imageInfos[1]);
          imagesNotifier.addDislike(imageInfos[2]);

          expect(imagesNotifier.value.localHistory.length, 3);
          expect(imagesNotifier.countOfLiked(), 1);
          expect(imagesNotifier.countOfDisliked(), 2);
          verify(() => likesHistoryDao.saveItem(any())).called(3);
        },
      );

      test(
        'Успешное удаление записей',
        () async {
          when(() => likesHistoryDao.deleteItemByUrl(any())).thenAnswer(
            (_) async {},
          );
          when(() => likesHistoryDao.saveItem(any())).thenAnswer(
            (_) async {},
          );

          imagesNotifier.addLike(imageInfos[0]);
          imagesNotifier.addDislike(imageInfos[1]);
          imagesNotifier.removeInteractionEntry(imageInfos[0].url);

          expect(imagesNotifier.countOfLiked(), equals(0));
          expect(imagesNotifier.countOfDisliked(), equals(1));
          verify(() => likesHistoryDao.deleteItemByUrl(any())).called(1);
        },
      );
    },
  );

  group(
    'Работа с загруженными с API информациями о картинках',
    () {
      test(
        'Удачное сохранение данных',
        () async {
          expect(imagesNotifier.getTopLoaded(AwailableAPIs.cats), isNull);

          await imagesNotifier.addLoadedInfo(imageInfos[0]);
          await imagesNotifier.addLoadedInfo(imageInfos[1]);

          expect(imagesNotifier.getTopLoaded(AwailableAPIs.cats)!.url, equals(imageInfos[0].url));
          expect(imagesNotifier.value.loadedImages[AwailableAPIs.cats]!.length, 2);
        },
      );

      test(
        'Удачное удаление',
        () async {
          await imagesNotifier.addLoadedInfo(imageInfos[0]);
          await imagesNotifier.addLoadedInfo(imageInfos[1]);
          imagesNotifier.removeLoadedInfo(imageInfos[0]);

          expect(imagesNotifier.getTopLoaded(AwailableAPIs.cats)!.url, equals(imageInfos[1].url));
          expect(imagesNotifier.value.loadedImages[AwailableAPIs.cats]!.length, 1);
        },
      );
    },
  );
}
