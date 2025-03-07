import 'dart:math';

import 'package:flutter/material.dart';
import 'details_page.dart';
import 'icon_counter.dart';
import 'image_swapper.dart';
import 'tools/api_requests.dart';
import 'tools/logger.dart';

class MainPage extends StatefulWidget {
  final VoidCallback? themeSwap;
  final int cardsToHold = 4;

  const MainPage({super.key, this.themeSwap});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<ImageResponse> info = [];
  List<Widget> cachedImages = [];
  AwailableAPIs chosenAPI = AwailableAPIs.cats;
  int liked = 0;
  int disliked = 0;
  int activeRequests = 0;

  void likingAction(bool isLike) {
    setState(() {
      if (isLike) {
        liked++;
      } else {
        disliked++;
      }
    });
  }

  void loadNew({bool forceUpdate = false}) {
    if (info.isNotEmpty) {
      info.removeAt(0);
      cachedImages.removeAt(0);
    }
    if (info.isNotEmpty && forceUpdate) {
      setState(() {
        info = info;
      });
    }
    logger.info("Load request made");
    activeRequests++;
    ApiRequests.makeRequest(chosenAPI).then((value) {
      if (value == null) {
        Future.delayed(const Duration(seconds: 10), loadNew);
        return;
      }
      logger.info("Load request finished");
      info.add(value);
      cachedImages.add(Image.network(value.url, color: Colors.transparent));
      activeRequests--;
      // activeRequests is checked on 0 to force update and build of hided images so that they are loaded in cache
      if (info.length == 1 || activeRequests == 0) {
        setState(() {
          info = info;
        });
      }
    });
  }

  void showDetails() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailsPage(info: info[0])));
  }

  void setAPI(AwailableAPIs api) {
    if (api == chosenAPI) return;
    setState(() {
      info = [];
      cachedImages = [];
      chosenAPI = api;
    });
  }

  @override
  Widget build(BuildContext context) {
    for (var _ in List.generate(
        max(0, widget.cardsToHold - info.length - activeRequests),
        (index) => index)) {
      loadNew();
    }

    return Scaffold(
        bottomNavigationBar: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color.fromARGB(255, 50, 50, 50)
                        : const Color.fromARGB(255, 200, 200, 200),
                    width: 3)),
            child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: MediaQuery.sizeOf(context).aspectRatio < 0.8 ? 3 : 1,
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10,
                      children: [
                        IconBurronCounter(
                          icon: const ImageIcon(
                              AssetImage("assets/icons/dislike.png"),
                              size: 25,
                              color: Color.fromARGB(255, 0, 81, 255)),
                          number: disliked,
                          onClick: () {
                            loadNew();
                            likingAction(false);
                          },
                        ),
                        IconBurronCounter(
                          icon: const ImageIcon(
                              AssetImage("assets/icons/like.png"),
                              size: 25,
                              color: Color.fromARGB(255, 255, 60, 0)),
                          number: liked,
                          onClick: () {
                            loadNew();
                            likingAction(true);
                          },
                        )
                      ],
                    )),
                    const Spacer(),
                    Flexible(
                        flex: 0,
                        child: Row(
                          spacing: 10,
                          children: [
                            IconButton(
                                onPressed: () => setAPI(AwailableAPIs.boys),
                                icon: const ImageIcon(
                                    AssetImage("assets/icons/boy.png"),
                                    size: 30)),
                            IconButton(
                                onPressed: () => setAPI(AwailableAPIs.cats),
                                icon: const ImageIcon(
                                    AssetImage("assets/icons/cat.png"),
                                    size: 30)),
                            IconButton(
                                onPressed: () => setAPI(AwailableAPIs.girls),
                                icon: const ImageIcon(
                                    AssetImage("assets/icons/girl.png"),
                                    size: 30))
                          ],
                        )),
                    const Spacer(),
                    Expanded(
                      flex: 1,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                          IconButton(
                            onPressed: widget.themeSwap,
                            icon: Icon(
                              Theme.of(context).brightness == Brightness.light
                                  ? Icons.sunny
                                  : Icons.mode_night,
                            ),
                          )
                        ]))
                  ],
                ))),
        body: Stack(children: [
          ...cachedImages,
          Align(
            alignment: Alignment.topLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  MediaQuery.sizeOf(context).shortestSide * 0.1 * 0.2),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image(
                  image: const AssetImage("assets/Kototinder_icon.png"),
                  width: MediaQuery.sizeOf(context).shortestSide * 0.1,
                  height: MediaQuery.sizeOf(context).shortestSide * 0.1),
            ),
          ),
          info.isNotEmpty
              ? ImageSwapper(
                  imageSource: info[0].url,
                  basicDescription:
                      "${info[0].name}\n${info[0].characteristics}",
                  onSwipe: loadNew,
                  onLeft: () {
                    loadNew();
                    likingAction(false);
                  },
                  onRight: () {
                    loadNew();
                    likingAction(true);
                  },
                  onExpand: showDetails,
                )
              : Container()
        ]));
  }
}
