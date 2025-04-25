import 'package:flutter_hw_lototinder/objectbox.g.dart';
import 'package:flutter_hw_lototinder/src/data/object_box_database.dart';
import 'package:flutter_hw_lototinder/src/domain/dao/likes_history_dao.dart';
import 'package:flutter_hw_lototinder/src/domain/model/awailable_apis.dart';
import 'package:flutter_hw_lototinder/src/domain/model/image_info.dart';
import 'package:path_provider/path_provider.dart';

class AppState {
  LikesHistoryDao dao;
  Map<AwailableAPIs, List<ImageInfo>> loadedImages = {};

  AppState({required this.dao});

  static Future<AppState> withObjectBox() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final objectBoxStore = await openStore(
      directory: '${docsDir.path}/obx_database',
    );
    final dao = LikesHistoryObjectBoxDataBase(objectBoxStore);
    return AppState(
      dao: dao,
    );
  }
}