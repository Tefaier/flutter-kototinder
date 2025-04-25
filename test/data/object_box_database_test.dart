import 'dart:io';

import 'package:flutter_hw_lototinder/objectbox.g.dart';
import 'package:flutter_hw_lototinder/src/data/object_box_database.dart';
import 'package:flutter_hw_lototinder/src/domain/model/awailable_apis.dart';
import 'package:flutter_hw_lototinder/src/domain/model/image_info.dart';
import 'package:flutter_hw_lototinder/src/domain/model/like_interaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late final LikesHistoryObjectBoxDataBase dataBase;
  late final String dataBasePath;
  const imageUrls = [
    "https://images.com/1.png",
    "https://images.com/2.png",
    "https://images.com/3.png"
  ];
  final imageInfos = imageUrls.map((e) => ImageInfo(apiSource: AwailableAPIs.cats, url: e, imageName: "cat", extraInfo: {})).toList();

  setUpAll(() async {
    final objectBoxStore = await openStore();
    dataBasePath = objectBoxStore.directoryPath;
    dataBase = LikesHistoryObjectBoxDataBase(objectBoxStore);
  });

  tearDownAll(() {
    Directory(dataBasePath).deleteSync(recursive: true);
  });

  setUp(() async {
    await dataBase.loadItems().then((list) async {
      for (var item in list) {
        await dataBase.deleteItem(item.id);
      } 
    });
  });

  test(
    'Проверка функции loadItems. Список должен быть пусть при создании',
    () async {
      final resList = await dataBase.loadItems();
      expect(resList, isEmpty);
    },
  );

  test(
    'Проверка функции saveItem',
    () async {
      var likeInteraction = LikeInteraction(
        imageInfo: imageInfos[0],
        actionTime: DateTime.now(),
      );

      await dataBase.saveItem(likeInteraction);

      var items = await dataBase.loadItems();

      expect(items.length, 1);
      expect(
          items.where((item) => item.imageInfo.url == imageUrls[0]).length, 1);
    },
  );

  test(
    'Проверка функции delete методов',
    () async {
      await dataBase.saveItem(LikeInteraction(
        imageInfo: imageInfos[0],
        actionTime: DateTime.now(),
      ));
      await dataBase.saveItem(LikeInteraction(
        imageInfo: imageInfos[1],
        actionTime: DateTime.now(),
      ));
      await dataBase.saveItem(LikeInteraction(
        imageInfo: imageInfos[2],
        actionTime: DateTime.now(),
      ));

      var items = await dataBase.loadItems();
      expect(items.length, 3);

      await dataBase.deleteItem(items[0].id);
      var newItems = (await dataBase.loadItems()).map((item) => item.id);
      expect(newItems.length, 2);
      expect(newItems.contains(items[1].id), isTrue);
      expect(newItems.contains(items[2].id), isTrue);

      await dataBase.deleteItemByUrl(imageUrls[2]);
      newItems = (await dataBase.loadItems()).map((item) => item.id);
      expect(newItems.length, 1);
      expect(newItems.contains(items[1].id), isTrue);
    },
  );
}
