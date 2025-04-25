import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hw_lototinder/src/domain/dao/likes_history_dao.dart';
import 'package:flutter_hw_lototinder/src/domain/model/like_interaction.dart';

class LikesHistoryNotifier extends ChangeNotifier {
  LikesHistoryDao dao;
  bool Function(LikeInteraction)? filter;
  bool Function(LikeInteraction)? finalFilter;
  bool showLiked = true;
  bool showDisliked = true;

  LikesHistoryNotifier({required this.dao});

  void setHistory(List<LikeInteraction> value) async {
    for (var val in value) {
      await dao.saveItem(val);
    }
    notifyListeners();
  }

  void setFilter(bool Function(LikeInteraction) filter) {
    filter = filter;
    notifyListeners();
  }

  void setFilterByBreed(String breedText) {
    setFilter((interaction) => interaction.imageInfo.imageName
        .toLowerCase()
        .contains(breedText.toLowerCase()));
  }

  void removeInteraction(LikeInteraction interaction) async {
    await dao.deleteItem(interaction.id);
    notifyListeners();
  }

  void setShowLiked(bool value) {
    if (showLiked == value) return;
    showLiked = value;
    notifyListeners();
  }

  void setShowDisliked(bool value) {
    if (showDisliked == value) return;
    showDisliked = value;
    notifyListeners();
  }

  Future<List<LikeInteraction>> getFiltered() async {
    var items = await dao.loadItems();
    if (filter == null && showLiked && showDisliked) return items;
    return items
        .where((interaction) =>
            ((showLiked && interaction.isLike) ||
                (showDisliked && !interaction.isLike)) &&
            (filter == null || filter!(interaction)))
        .toList();
  }
}

class LikesHistoryInheritedNotifier
    extends InheritedNotifier<LikesHistoryNotifier> {
  const LikesHistoryInheritedNotifier({
    super.key,
    required super.notifier,
    required super.child,
  });

  static LikesHistoryNotifier of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<LikesHistoryInheritedNotifier>();

    final notifier = result?.notifier;
    if (notifier == null) {
      throw StateError('No LikesHistoryInheritedNotifier found in context');
    }

    return notifier;
  }
}
