class ImageInfo {
  String url;
  String imageName;
  Map<String, String>? extraInfo;

  ImageInfo({required this.url, required this.imageName, this.extraInfo});

  factory ImageInfo.fromJson(Map<String, Object?> json) {
    return ImageInfo(
        url: (json["url"] ?? '') as String,
        imageName: (json["name"] ?? '') as String,
        extraInfo: json["extra"] as Map<String, String>?);
  }
}
