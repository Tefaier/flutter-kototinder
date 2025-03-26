import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/model/like_interaction.dart';
import 'package:flutter_hw_lototinder/src/navigation/navigation_manager.dart';
import 'package:flutter_hw_lototinder/src/state/likes_history_notifier.dart';
import 'package:flutter_hw_lototinder/src/widget/components/bottom_navigation_holder.dart';
import 'package:flutter_hw_lototinder/src/widget/components/input_with_delete.dart';
import 'package:flutter_hw_lototinder/src/widget/components/likes_history_list.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});
  
  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  late LikesHistoryNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = LikesHistoryNotifier(history: []);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notifier.setHistory(ModalRoute.of(context)?.settings.arguments as List<LikeInteraction>);
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  void popSelf() {
    NavigationManager.instance.pop(_notifier.history);
  }

  @override
  Widget build(BuildContext context) {
    return LikesHistoryInheritedNotifier(
      notifier: _notifier, 
      child: Scaffold(
        body: HistoryList(content: _notifier.getFiltered()),
        appBar: PreferredSize(preferredSize: Size.fromWidth(100), child: InputWithDelete(onChange: (value) => _notifier.setFilterByBreed(value))),
        bottomNavigationBar: BottomNavigationHolder(children: [TextButton(onPressed: popSelf, child: const Text(style: TextStyle(fontSize: 40, wordSpacing: 5, height: 50), "CLOSE"))]),
      )
    );
  }
}
