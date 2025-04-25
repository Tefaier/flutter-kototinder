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
    likesHistoryDao = MockLikesHistoryDao();
    imagesNotifier = ImagesNotifier(value: AppState(dao: likesHistoryDao));
  });

  tearDownAll(() {
    reset(likesHistoryDao);
  });

  setUp(() {
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

      imagesNotifier.synchWithRepository();
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
        'Неудачная подгрузка данных',
        () async {
          // arrange
          when(() => shoppingListDao.loadItems()).thenThrow(Exception());

          // act
          await shoppingListManager.loadItems();

          // assert
          expect(shoppingListManager.state, equals(ShoppingListState.error));
        },
      );
    },
  );

  group(
    'Сохранение покупки',
    () {
      const name = 'Ratatouille';
      const name2 = 'Pizza';
      const name3 = 'Ramen';
      const item = ShoppingItem(
        id: 'unique_id',
        name: name,
      );

      setUp(() {
        registerFallbackValue(item);
      });

      test(
        'Удачное сохранение данных',
        () async {
          // arrange
          when(() => shoppingListDao.saveItem(any<ShoppingItem>()))
              .thenAnswer((_) async {});

          // act
          await shoppingListManager.addItem(name);

          // assert
          expect(
            shoppingListManager.items.map((item) => item.name).toList(),
            contains(name),
          );
          expect(shoppingListManager.state, equals(ShoppingListState.idle));

          final verification = verify(() => shoppingListDao
              .saveItem(captureAny(that: isA<ShoppingItem>()))).captured;

          expect(verification.first.name, name);
        },
      );

      test(
        'При сохранении произошла ошибка',
        () async {
          // arrange
          when(() => shoppingListDao.saveItem(any())).thenThrow(Exception());

          // act
          await shoppingListManager.addItem(name2);

          // assert
          expect(
            shoppingListManager.items.map((item) => item.name).toList(),
            isNot(contains(name2)),
          );
          expect(shoppingListManager.state, equals(ShoppingListState.idle));

          verify(() => shoppingListDao.saveItem(any())).called(1);
        },
      );

      test(
        'Нельзя вызвать сохранение дважды',
        () {
          // arrange
          when(() => shoppingListDao.saveItem(any()))
              .thenAnswer((_) => Future.delayed(const Duration(seconds: 3)));

          // act
          shoppingListManager.addItem(name3);
          shoppingListManager.addItem(name3);

          // assert
          verify(() => shoppingListDao.saveItem(any())).called(1);
        },
      );

      test(
        'Нельзя сохранить вещь без имени',
        () {
          // arrange
          when(() => shoppingListDao.saveItem(any())).thenAnswer((_) async {});

          // act
          shoppingListManager.addItem('');

          // assert
          verifyNever(() => shoppingListDao.saveItem(any()));
        },
      );
    },
  );
}
