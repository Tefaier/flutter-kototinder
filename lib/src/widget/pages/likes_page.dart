import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/model/like_interaction.dart';
import 'package:flutter_hw_lototinder/src/navigation/navigation_manager.dart';
import 'package:flutter_hw_lototinder/src/state/likes_history_notifier.dart';
import 'package:flutter_hw_lototinder/src/utils/logger.dart';
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
  static String _prev_text = "";

  @override
  void initState() {
    super.initState();
    logger.info("Likes page init");
  }

  @override
  void dispose() {
    super.dispose();
    logger.info("Likes page dispose");
  }

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
                    title: InputWithDelete(
                        initText: _prev_text,
                        onChange: (value) {
                          LikesHistoryInheritedNotifier.of(context)
                              .setFilterByBreed(value);
                          _prev_text = value;
                        })),
                body: HistoryList(
                    content: LikesHistoryInheritedNotifier.of(context)
                        .getFiltered()),
                bottomNavigationBar: BottomNavigationHolder(children: [
                  TextButton(
                      onPressed: popSelf,
                      child: const Text(
                          style: TextStyle(fontSize: 40, letterSpacing: 3),
                          "CLOSE"))
                ]),
              )));
}
