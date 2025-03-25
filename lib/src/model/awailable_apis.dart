import "package:flutter_hw_lototinder/src/model/image_info.dart";

ImageInfo? thecatapiParser(dynamic info) {
  if (info == null) return null;
  Map<String, Object> parsed = {};
  info = info[0];
  parsed["api"] = AwailableAPIs.cats;
  parsed["url"] = info["url"];
  var breedsInfo = info["breeds"][0];
  parsed["name"] = breedsInfo["name"];
  var extra = <String, Object>{};
  extra["general"] = breedsInfo["temperament"];
  extra["description"] = breedsInfo["description"];
  parsed["extra"] = extra;
  return ImageInfo.fromJson(parsed);
}

enum AwailableAPIs {
  cats("thecatapi", "https://api.thecatapi.com/v1/images/search?has_breeds=1&api_key=live_o8038oqDil8T8qkhapTShngvUDx2B8gjkmIIAXFC0m7Js2rsqL6y8GddBEH6vQOf", thecatapiParser);

  final String name;
  final String getRequest;
  final ImageInfo? Function(dynamic) responseParser;

  const AwailableAPIs(this.name, this.getRequest, this.responseParser);
}