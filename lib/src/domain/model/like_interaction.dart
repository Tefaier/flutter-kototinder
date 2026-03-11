import 'package:flutter_hw_lototinder/src/data/likes_history_item_entity.dart';
import 'package:flutter_hw_lototinder/src/domain/model/image_info.dart';

class LikeInteraction {
  int id;
  ImageInfo imageInfo;
  DateTime actionTime;
  bool isLike;

  LikeInteraction(
      {this.id = 0,
      required this.imageInfo,
      required this.actionTime,
      this.isLike = true});

  factory LikeInteraction.fromItemEntity(LikesHistoryItemEntity entity) {
    return LikeInteraction(
        id: entity.id,
        imageInfo: ImageInfo.fromInfoItemEntity(entity.imageInfo.target!),
        actionTime: entity.actionTime,
        isLike: entity.isLike);
  }
}
