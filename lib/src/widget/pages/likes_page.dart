import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/model/like_interaction.dart';
import 'package:flutter_hw_lototinder/src/state/likes_history_notifier.dart';

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

  @override
  Widget build(BuildContext context) {
    return LikesHistoryInheritedNotifier(
      notifier: _notifier, 
      child: Scaffold(
        body: Container(),
      )
    );
  }
}
