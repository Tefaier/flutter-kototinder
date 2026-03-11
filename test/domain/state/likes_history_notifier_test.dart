import 'package:flutter_hw_lototinder/src/domain/dao/likes_history_dao.dart';
import 'package:flutter_hw_lototinder/src/domain/model/awailable_apis.dart';
import 'package:flutter_hw_lototinder/src/domain/model/image_info.dart';
import 'package:flutter_hw_lototinder/src/domain/model/like_interaction.dart';
import 'package:flutter_hw_lototinder/src/domain/state/likes_history_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../dao/mock_likes_history_dao.dart';

void main() {
  late final LikesHistoryNotifier historyNotifier;
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
          imageName: e.split('/').last,
          extraInfo: {}))
      .toList();

  final defaultList = [
    LikeInteraction(
        id: 0,
        imageInfo: imageInfos[0],
        actionTime: DateTime.now(),
        isLike: false),
    LikeInteraction(
        id: 1,
        imageInfo: imageInfos[1],
        actionTime: DateTime.now(),
        isLike: true)
  ];

  setUpAll(() {
    likesHistoryDao = MockLikesHistoryDao();
    when(() => likesHistoryDao.loadItems())
        .thenAnswer((_) async => Future.value(<LikeInteraction>[]));

    historyNotifier = LikesHistoryNotifier(dao: likesHistoryDao);
  });

  tearDownAll(() {
    reset(likesHistoryDao);
  });

  setUp(() {
    reset(likesHistoryDao);
    historyNotifier.localHistory = [];
    historyNotifier.filter = null;
    historyNotifier.showDisliked = true;
    historyNotifier.showLiked = true;
  });

  test(
    'Проверка синхронизации с репозиторием',
    () async {
      when(() => likesHistoryDao.loadItems()).thenAnswer(
        (_) async {
          return Future.value(defaultList);
        },
      );

      expect(historyNotifier.localHistory.length, 0);

      await historyNotifier.synchWithRepository();
      expect(historyNotifier.localHistory.length, 2);
      verify(() => likesHistoryDao.loadItems()).called(1);
    },
  );

  test(
    'Проверка удаления',
    () async {
      bool trigger = false;

      when(() => likesHistoryDao.loadItems()).thenAnswer(
        (_) async {
          return Future.value(defaultList);
        },
      );
      when(() => likesHistoryDao.deleteItem(0)).thenAnswer(
        (_) async {
          trigger = true;
        },
      );

      await historyNotifier.synchWithRepository();
      historyNotifier.removeInteraction(defaultList[0]);

      expect(historyNotifier.localHistory.length, equals(1));
      expect(trigger, equals(true));
      verify(() => likesHistoryDao.deleteItem(0)).called(1);
    },
  );

  group(
    'Проверка фильтров',
    () {
      setUp(() {
        historyNotifier.localHistory = defaultList;
        historyNotifier.filter = null;
        historyNotifier.showDisliked = true;
        historyNotifier.showLiked = true;
      });

      test(
        'Проверка фильтров на лайки и дизлайки',
        () async {
          expect(historyNotifier.getFiltered().length, equals(2));
          historyNotifier.setShowLiked(false);
          expect(historyNotifier.getFiltered().length, equals(1));
          expect(historyNotifier.getFiltered()[0].id, equals(0));
          historyNotifier.setShowLiked(true);
          expect(historyNotifier.getFiltered().length, equals(2));
          historyNotifier.setShowDisliked(false);
          expect(historyNotifier.getFiltered().length, equals(1));
          expect(historyNotifier.getFiltered()[0].id, equals(1));
          historyNotifier.setShowDisliked(true);
          expect(historyNotifier.getFiltered().length, equals(2));
          historyNotifier.setShowDisliked(false);
          historyNotifier.setShowLiked(false);
          expect(historyNotifier.getFiltered().length, equals(0));
        },
      );

      test(
        'Проверка фильтров на имя',
        () async {
          historyNotifier.setFilterByBreed("1.PnG");
          expect(historyNotifier.getFiltered().length, equals(1));
          expect(historyNotifier.getFiltered()[0].id, equals(0));
          historyNotifier.setShowDisliked(false);
          expect(historyNotifier.getFiltered().length, equals(0));
        },
      );
    },
  );
}
