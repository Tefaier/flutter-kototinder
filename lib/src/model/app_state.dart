import 'package:flutter_hw_lototinder/src/model/awailable_apis.dart';
import 'package:flutter_hw_lototinder/src/model/image_info.dart';
import 'package:flutter_hw_lototinder/src/model/like_interaction.dart';

class AppState {
  List<LikeInteraction> likesHistory = [];
  Map<AwailableAPIs, List<ImageInfo>> loadedImages = {};

  AppState();

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return super == other;
  }
}