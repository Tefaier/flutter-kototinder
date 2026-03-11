import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/domain/state/images_history_notifier.dart';
import 'package:flutter_hw_lototinder/src/navigation/navigation_manager.dart';
import 'package:flutter_hw_lototinder/src/domain/state/likes_history_notifier.dart';
import 'package:flutter_hw_lototinder/src/widget/components/bottom_navigation_holder.dart';
import 'package:flutter_hw_lototinder/src/widget/components/input_with_delete.dart';
import 'package:flutter_hw_lototinder/src/widget/components/likes_history_list.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  static String prevText = "";
  static bool prevShowLiked = true;
  static bool prevShowDisliked = true;

  void popSelf() {
    getIt<ImagesNotifier>().synchWithRepository();
    getIt<NavigationManager>().pop();
  }

  @override
  Widget build(BuildContext context) => LikesHistoryInheritedNotifier(
      notifier: getIt<LikesHistoryNotifier>(),
      child: Builder(
          builder: (context) => Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InputWithDelete(
                          initText: prevText,
                          onChange: (value) {
                            LikesHistoryInheritedNotifier.of(context)
                                .setFilterByBreed(value);
                            prevText = value;
                          }),
                    )),
                body: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: min(
                                600, MediaQuery.sizeOf(context).width * 0.95)),
                        child: HistoryList(content: LikesHistoryInheritedNotifier.of(context).getFiltered()))),
                bottomNavigationBar: BottomNavigationHolder(children: [
                  IconButton(
                      onPressed: () {
                        prevShowDisliked = !prevShowDisliked;
                        LikesHistoryInheritedNotifier.of(context)
                            .setShowDisliked(prevShowDisliked);
                      },
                      icon: ImageIcon(
                          const AssetImage("assets/icons/dislike.png"),
                          size: 25,
                          color: prevShowDisliked
                              ? const Color.fromARGB(255, 0, 81, 255)
                              : Colors.grey)),
                  TextButton(
                      onPressed: popSelf,
                      child: const Text(
                          style: TextStyle(fontSize: 30, letterSpacing: 5),
                          "CLOSE")),
                  IconButton(
                      onPressed: () {
                        prevShowLiked = !prevShowLiked;
                        LikesHistoryInheritedNotifier.of(context)
                            .setShowLiked(prevShowLiked);
                      },
                      icon: ImageIcon(const AssetImage("assets/icons/like.png"),
                          size: 25,
                          color: prevShowLiked
                              ? const Color.fromARGB(255, 255, 60, 0)
                              : Colors.grey)),
                ]),
              )));
}
