import 'package:flutter_hw_lototinder/src/data/image_info_item_entity.dart';
import 'package:flutter_hw_lototinder/src/domain/model/like_interaction.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class LikesHistoryItemEntity {
  @Id()
  int id;
  final imageInfo = ToOne<ImageInfoItemEntity>();
  DateTime actionTime;
  bool isLike;

  LikesHistoryItemEntity({
    this.id = 0,
    required this.actionTime,
    required this.isLike,
  });

  factory LikesHistoryItemEntity.fromModel(LikeInteraction info) {
    var entity = LikesHistoryItemEntity(actionTime: info.actionTime, isLike: info.isLike);
    entity.imageInfo.target = ImageInfoItemEntity.fromModel(info.imageInfo);
    return entity;
  }
}
