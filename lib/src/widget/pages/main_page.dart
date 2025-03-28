import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/model/awailable_apis.dart';
import 'package:flutter_hw_lototinder/src/model/image_info.dart' as image_info;
import 'package:flutter_hw_lototinder/src/model/app_state.dart' as app_model;
import 'package:flutter_hw_lototinder/src/navigation/navigation_manager.dart';
import 'package:flutter_hw_lototinder/src/state/images_history_notifier.dart';
import 'package:flutter_hw_lototinder/src/state/images_loader.dart';
import 'package:flutter_hw_lototinder/src/utils/logger.dart';
import 'package:flutter_hw_lototinder/src/widget/components/bottom_navigation_holder.dart';
import 'package:flutter_hw_lototinder/src/widget/components/logo_icon.dart';
import 'package:get_it/get_it.dart';
import '../components/icon_counter.dart';
import '../components/image_swapper.dart';

GetIt getIt = GetIt.instance;

class MainPage extends StatelessWidget {
  final VoidCallback? themeSwap;

  const MainPage({super.key, this.themeSwap});

  @override
  Widget build(BuildContext context) {
    return ImagesInheritedNotifier(
      notifier: getIt<ImagesNotifier>(),
      child: MainPageContent(themeSwap: themeSwap),
    );
  }
}

class MainPageContent extends StatefulWidget {
  final VoidCallback? themeSwap;
  final int cardsToHold = 4;

  const MainPageContent({super.key, this.themeSwap});

  @override
  State<MainPageContent> createState() => _MainPageState();
}

class _MainPageState extends State<MainPageContent> {
  ImagesNotifier? _notifier;
  image_info.ImageInfo? shownImage;
  List<Widget> cachedImages = [];
  AwailableAPIs chosenAPI = AwailableAPIs.cats;

  void likingAction(bool isLike) {
    if (shownImage != null) {
      _notifier!.addInteractionEntry(shownImage!, isLike);
    }
  }

  void destroyShown() {
    _notifier!.removeLoadedInfo(shownImage!);
    loadNew();
    setState(() {
      shownImage = _notifier!.getTopLoaded(chosenAPI);
    });
  }

  void loadNew() {
    getIt<ImagesLoader>().loadImages(1, chosenAPI, _notifier!.addLoadedInfo);
  }

  void showDetails() {
    if (shownImage != null) {
      getIt<NavigationManager>().openDetails(shownImage!);
    }
  }

  void setAPI(AwailableAPIs api) {
    if (api == chosenAPI) return;
    getIt<ImagesLoader>().loadImagesUpTo(
        ImagesLoader.keepLoadedSetting,
        () => (_notifier!.value.loadedImages[api]?.length ?? 0),
        api,
        _notifier!.addLoadedInfo);
    setState(() {
      shownImage = _notifier!.value.loadedImages[api]?.firstOrNull;
      cachedImages = [];
      chosenAPI = api;
    });
  }

  void showLikesPage() {
    getIt<NavigationManager>()
        .openLikeHistory(_notifier!.value.likesHistory)
        .then((newHistory) {
      _notifier!.value.likesHistory = newHistory;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    logger.info("Main page init");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notifier ??= ImagesInheritedNotifier.of(context);
    getIt<ImagesLoader>().loadImagesUpTo(
        widget.cardsToHold,
        () => (_notifier!.value.loadedImages[chosenAPI]?.length ?? 0),
        chosenAPI,
        _notifier!.addLoadedInfo);
    shownImage ??= _notifier!.value.loadedImages[chosenAPI]?.firstOrNull;
    cachedImages = (_notifier!.value.loadedImages[chosenAPI] ?? [])
        .map((info) => Image.network(info.url,
            key: ObjectKey(info.url), color: Colors.transparent))
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    logger.info("Main page dispose");
    getIt<ImagesNotifier>().dispose();
    // TODO check if to terminate ImagesLoader operations
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationHolder(children: [
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
                    number: _notifier!.countOfDisliked(),
                    onClick: () {
                      loadNew();
                      likingAction(false);
                      destroyShown();
                    },
                  ),
                  IconBurronCounter(
                    icon: const ImageIcon(AssetImage("assets/icons/like.png"),
                        size: 25, color: Color.fromARGB(255, 255, 60, 0)),
                    number: _notifier!.countOfLiked(),
                    onClick: () {
                      loadNew();
                      likingAction(true);
                      destroyShown();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 5),
                    onPressed: showLikesPage,
                    child: const Text("Expand"),
                  )
                ],
              )),
          Flexible(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            spacing: 10,
            children: [
              IconButton(
                  onPressed: () => setAPI(AwailableAPIs.cats),
                  icon: const ImageIcon(AssetImage("assets/icons/cat.png"),
                      size: 30))
            ],
          )),
          Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              onPressed: widget.themeSwap,
              icon: Icon(
                Theme.of(context).brightness == Brightness.light
                    ? Icons.sunny
                    : Icons.mode_night,
              ),
            )
          ]))
        ]),
        body: Stack(children: [
          ...cachedImages,
          const Align(
            alignment: Alignment.topLeft,
            child: LogoIcon(),
          ),
          shownImage != null
              ? ImageSwapper(
                  imageSource: shownImage!.url,
                  basicDescription:
                      "${shownImage!.imageName}\n${shownImage!.extraInfo!["general"]}",
                  onSwipe: destroyShown,
                  onLeft: () {
                    likingAction(false);
                    destroyShown();
                  },
                  onRight: () {
                    likingAction(true);
                    destroyShown();
                  },
                  onExpand: showDetails,
                )
              : Container()
        ]));
  }
}
