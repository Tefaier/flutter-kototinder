import 'package:flutter/material.dart';

import 'package:flutter_hw_lototinder/src/model/image_info.dart' as model;
import 'package:flutter_hw_lototinder/src/widget/components/loadable_image.dart';

class DetailsPage extends StatelessWidget {
  final model.ImageInfo info;

  const DetailsPage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    var contentWidgets = [
      Flexible(
          flex: 2,
          child: LoadableImage(url: info.url, fit: MediaQuery.sizeOf(context).aspectRatio >= 1 ? BoxFit.fitHeight : BoxFit.fitWidth)),
      Flexible(
          flex: 3,
          child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20),
                    children: [
                      const TextSpan(
                          text: "Имя: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${info.imageName}\n'),
                      const TextSpan(
                          text: "Характеристики: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${info.extraInfo?['characteristics'] ?? ''}\n'),
                      const TextSpan(
                          text: "Описание: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${info.extraInfo?['description'] ?? ''}\n')
                    ]),
                softWrap: true,
              )))
    ];

    return Scaffold(
        body: TapRegion(
            onTapOutside: (event) => Navigator.pop(context),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.9,
                    maxHeight: MediaQuery.sizeOf(context).height * 0.9),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Card.filled(
                      shadowColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                      elevation: 30,
                      color: Theme.of(context).cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: MediaQuery.sizeOf(context).aspectRatio >= 1
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: MediaQuery.sizeOf(context).width * 0.03,
                              children: contentWidgets,
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: MediaQuery.sizeOf(context).height * 0.03,
                              children: contentWidgets,
                            )),
                    )),
              ),
            )));
  }
}
