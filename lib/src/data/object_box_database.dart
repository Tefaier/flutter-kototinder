import 'package:flutter_hw_lototinder/objectbox.g.dart';
import 'package:flutter_hw_lototinder/src/data/likes_history_item_entity.dart';
import 'package:flutter_hw_lototinder/src/domain/dao/likes_history_dao.dart';
import 'package:flutter_hw_lototinder/src/domain/model/like_interaction.dart';


class LikesHistoryObjectBoxDataBase implements LikesHistoryDao {
  final Store _store;

  LikesHistoryObjectBoxDataBase(this._store);

  @override
  Future<List<LikeInteraction>> loadItems() async {
    final box = _store.box<LikesHistoryItemEntity>();

    final entities = box.getAll();
    final items = entities
        .map(
          (entity) => LikeInteraction.fromItemEntity(entity),
        )
        .toList();

    return items;
  }

  @override
  Future<void> saveItem(LikeInteraction item) async {
    final box = _store.box<LikesHistoryItemEntity>();

    final entity = LikesHistoryItemEntity.fromModel(item);

    box.put(entity);
  }

  @override
  Future<void> deleteItem(int id) async {
    final box = _store.box<LikesHistoryItemEntity>();

    final query = box.query(LikesHistoryItemEntity_.id.equals(id)).build();
    final boxId = query.findFirst()?.id;
    query.close();

    if (boxId == null) {
      return;
    }

    box.remove(boxId);
  }

  @override
  Future<void> deleteItemByUrl(String url) async {
    final box = _store.box<LikesHistoryItemEntity>();

    final ordersQueryBuilder = box.query()..build();
    ordersQueryBuilder.link(LikesHistoryItemEntity_.imageInfo, ImageInfoItemEntity_.url.equals(url));
    final query = ordersQueryBuilder.build();

    final boxId = query.findFirst()?.id;
    query.close();

    if (boxId == null) {
      return;
    }

    box.remove(boxId);
  }

  @override
  Future<void> dispose() async => _store.close();
  
  @override
  Future<int> getLikeCount(bool isLike) {
    final box = _store.box<LikesHistoryItemEntity>();
    final query = box.query(LikesHistoryItemEntity_.isLike.equals(isLike)).build();
    final counter = query.count();
    query.close();
    return Future<int>.value(counter);
  }
}
