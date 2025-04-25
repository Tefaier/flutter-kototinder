import 'dart:convert';

import 'package:flutter_hw_lototinder/src/domain/model/image_info.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ImageInfoItemEntity {
  @Id()
  int id;
  int apiSourceID;
  @Unique()
  String url;
  String imageName;
  String extraInfoMap;

  ImageInfoItemEntity(
      {this.id = 0,
      required this.apiSourceID,
      required this.url,
      required this.imageName,
      required this.extraInfoMap});

  factory ImageInfoItemEntity.fromModel(ImageInfo info) {
    return ImageInfoItemEntity(
        id: info.id,
        apiSourceID: info.apiSource.index,
        url: info.url,
        imageName: info.imageName,
        extraInfoMap:
            info.extraInfo != null ? jsonEncode(info.extraInfo) : '{}');
  }
}
