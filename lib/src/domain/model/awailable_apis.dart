import "package:flutter_hw_lototinder/src/domain/model/image_info.dart";

ImageInfo? thecatapiParser(dynamic info) {
  if (info == null) return null;
  Map<String, Object> parsed = {};
  info = info[0];
  parsed["api"] = AwailableAPIs.cats;
  parsed["url"] = info["url"];
  var breedsInfo = info["breeds"] as List;
  if (breedsInfo.isEmpty) return null;
  parsed["name"] = breedsInfo[0]["name"];
  var extra = <String, String>{};
  extra["general"] = breedsInfo[0]["temperament"];
  extra["description"] = breedsInfo[0]["description"];
  extra["origin"] = breedsInfo[0]["origin"];
  extra["lifespan"] = breedsInfo[0]["life_span"];
  extra["adaptability"] = breedsInfo[0]["adaptability"].toString();
  extra["affection_level"] = breedsInfo[0]["affection_level"].toString();
  extra["intelligence"] = breedsInfo[0]["intelligence"].toString();
  parsed["extra"] = extra;
  return ImageInfo.fromJson(parsed);
}

ImageInfo? testParser(dynamic info) {
  return ImageInfo(apiSource: AwailableAPIs.test, url: "", imageName: "");
}

enum AwailableAPIs {
  cats("thecatapi", "https://api.thecatapi.com/", "https://api.thecatapi.com/v1/images/search?has_breeds=1&api_key=${const String.fromEnvironment("thecatapi_key")}", thecatapiParser),
  test("for tests", "https://google.com/", "https://google.com/", testParser);

  final String name;
  final String printName;
  final String getRequest;
  final ImageInfo? Function(dynamic) responseParser;

  const AwailableAPIs(this.name, this.printName, this.getRequest, this.responseParser);
}
