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

enum AwailableAPIs {
  cats("thecatapi", "https://api.thecatapi.com/v1/images/search?has_breeds=1&api_key=live_o8038oqDil8T8qkhapTShngvUDx2B8gjkmIIAXFC0m7Js2rsqL6y8GddBEH6vQOf", thecatapiParser),
  notCats("thecatapi", "https://api.thecatapi.com/v1/images/search?has_breeds=1&api_key=live_o8038oqDil8T8qkhapTShngvUDx2B8gjkmIIAXFC0m7Js2rsqL6y8GddBEH6vQOf", thecatapiParser);

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