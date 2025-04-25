import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hw_lototinder/src/domain/dao/likes_history_dao.dart';
import 'package:flutter_hw_lototinder/src/domain/model/like_interaction.dart';

class LikesHistoryNotifier extends ChangeNotifier {
  LikesHistoryDao dao;
  List<LikeInteraction> localHistory = [];
  bool Function(LikeInteraction)? filter;
  bool Function(LikeInteraction)? finalFilter;
  bool showLiked = true;
  bool showDisliked = true;

  LikesHistoryNotifier({required this.dao}) {
    synchWithRepository();
  }

  void synchWithRepository() async {
    localHistory = await dao.loadItems();
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
    localHistory = localHistory.where((item) => item.id != interaction.id).toList();
    notifyListeners();
    await dao.deleteItem(interaction.id);
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

  List<LikeInteraction> getFiltered() {
    if (filter == null && showLiked && showDisliked) return localHistory;
    return localHistory
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
