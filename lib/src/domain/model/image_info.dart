import 'dart:convert';

import 'package:flutter_hw_lototinder/src/data/image_info_item_entity.dart';
import 'package:flutter_hw_lototinder/src/domain/model/awailable_apis.dart';

class ImageInfo {
  int id;
  AwailableAPIs apiSource;
  String url;
  String imageName;
  Map<String, String>? extraInfo;

  ImageInfo(
      {this.id = 0,
      required this.apiSource,
      required this.url,
      required this.imageName,
      this.extraInfo});

  factory ImageInfo.fromJson(Map<String, Object?> json) {
    return ImageInfo(
        apiSource: json["api"] as AwailableAPIs,
        url: json["url"] as String,
        imageName: (json["name"] ?? '') as String,
        extraInfo: json["extra"] as Map<String, String>);
  }

  factory ImageInfo.fromInfoItemEntity(ImageInfoItemEntity entity) {
    Map<String, String> decoded = Map.castFrom(jsonDecode(entity.extraInfoMap));
    return ImageInfo(
        id: entity.id,
        apiSource: AwailableAPIs.values[entity.apiSourceID],
        url: entity.url,
        imageName: entity.imageName,
        extraInfo: decoded);
  }
}
