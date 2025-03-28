import 'package:flutter_hw_lototinder/src/model/awailable_apis.dart';

class ImageInfo {
  AwailableAPIs apiSource;
  String url;
  String imageName;
  Map<String, String>? extraInfo;

  ImageInfo({required this.apiSource, required this.url, required this.imageName, this.extraInfo});

  factory ImageInfo.fromJson(Map<String, Object?> json) {
    return ImageInfo(
        apiSource: json["api"] as AwailableAPIs,
        url: json["url"] as String,
        imageName: (json["name"] ?? '') as String,
        extraInfo: json["extra"] as Map<String, String>);
  }
}
