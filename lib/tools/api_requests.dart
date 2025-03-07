import 'dart:convert';

import 'package:http/http.dart' as http;

class ImageResponse {
  final String url;
  final String name;
  final String characteristics;
  final String description;

  ImageResponse({required this.url, required this.name, required this.characteristics, required this.description});

  factory ImageResponse.fromJson(Map<String, String?> json) {
    json.putIfAbsent("url", () => "");
    json.putIfAbsent("name", () => "");
    json.putIfAbsent("general", () => "");
    json.putIfAbsent("description", () => "");
    return ImageResponse(url: json["url"]!, name: json["name"]!, characteristics: json["general"]!, description: json["description"]!);
  }
}

ImageResponse? thecatapiParser(dynamic info) {
  if (info == null) return null;
  Map<String, String?> parsed = {};
  info = info[0];
  parsed["url"] = info["url"];
  var breedsInfo = info["breeds"][0];
  parsed["name"] = breedsInfo["name"];
  parsed["general"] = breedsInfo["temperament"];
  parsed["description"] = breedsInfo["description"];
  return ImageResponse.fromJson(parsed);
}

ImageResponse? nekosapiParser(dynamic info) {
  if (info == null) return null;
  Map<String, String?> parsed = {};
  info = info["results"];
  info = info[0];
  parsed["url"] = info["url"];
  parsed["name"] = "By ${info["artist_name"]}";
  parsed["general"] = "";
  parsed["description"] = "";
  return ImageResponse.fromJson(parsed);
}

// propable api
// https://api.nekosapi.com/v4/images/random?tags=boy&without_tags=girl&rating=safe
// https://nekosapi.com/docs/images/random
// problem - is not SFW even with rating safe

enum AwailableAPIs {
  cats("thecatapi", "https://api.thecatapi.com/v1/images/search?has_breeds=1&api_key=live_o8038oqDil8T8qkhapTShngvUDx2B8gjkmIIAXFC0m7Js2rsqL6y8GddBEH6vQOf", thecatapiParser),
  boys("nekosSFWboys", "https://nekos.best/api/v2/husbando", nekosapiParser),
  girls("nekosSFWgirls", "https://nekos.best/api/v2/neko", nekosapiParser);

  final String name;
  final String getRequest;
  final ImageResponse? Function(dynamic) responseParser;

  const AwailableAPIs(this.name, this.getRequest, this.responseParser);
}

class ApiRequests {
  ApiRequests._();

  static Future<ImageResponse?> makeRequest(AwailableAPIs api) {
    return http.get(Uri.parse(api.getRequest)).then((response) => jsonDecode(response.body)).catchError((handleError) => null).then((result) => api.responseParser(result));
  }
}