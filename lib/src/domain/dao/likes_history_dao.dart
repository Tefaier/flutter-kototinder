import 'package:flutter_hw_lototinder/src/domain/model/like_interaction.dart';

abstract class LikesHistoryDao {
  /// Загрузить все сохранённые элементы.
  Future<List<LikeInteraction>> loadItems();

  /// Сохранить (добавить) элемент.
  Future<void> saveItem(LikeInteraction item);

  /// Удалить элемент по ID.
  Future<void> deleteItem(int id);

  /// Удалить элемент по ID.
  Future<void> deleteItemByUrl(String url);

  Future<void> dispose();
}
