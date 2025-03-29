import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/navigation/navigation_manager.dart';
import 'package:flutter_hw_lototinder/src/state/likes_history_notifier.dart';
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

  void popSelf() {
    getIt<NavigationManager>().pop(getIt<LikesHistoryNotifier>().history);
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
                        child: HistoryList(
                            content: LikesHistoryInheritedNotifier.of(context)
                                .getFiltered()))),
                bottomNavigationBar: BottomNavigationHolder(children: [
                  TextButton(
                      onPressed: popSelf,
                      child: const Text(
                          style: TextStyle(fontSize: 30, letterSpacing: 5),
                          "CLOSE"))
                ]),
              )));
}
