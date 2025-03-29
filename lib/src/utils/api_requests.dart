import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_hw_lototinder/src/model/image_info.dart';
import 'package:flutter_hw_lototinder/src/model/awailable_apis.dart';

// propable api
// https://api.nekosapi.com/v4/images/random?tags=boy&without_tags=girl&rating=safe
// https://nekosapi.com/docs/images/random
// problem - is not SFW even with rating safe

// https://rabbit-api-two.vercel.app/api/random
// rabbits

class ApiRequests {
  ApiRequests._();

  static Future<ImageInfo?> makeRequest(AwailableAPIs api, void Function()? onError) {
    return http.get(Uri.parse(api.getRequest)).then((response) => jsonDecode(response.body)).catchError((handleError) {
      if (onError != null) onError();
      return null;
    }).then((result) => api.responseParser(result));
  }
}