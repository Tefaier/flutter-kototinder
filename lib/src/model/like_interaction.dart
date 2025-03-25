import 'package:flutter_hw_lototinder/src/model/image_info.dart';

class LikeInteraction {
  ImageInfo imageInfo;
  DateTime actionTime;
  bool isLike;

  LikeInteraction({required this.imageInfo, required this.actionTime, this.isLike = true});
}
